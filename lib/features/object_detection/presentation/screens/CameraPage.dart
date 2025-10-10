
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxPainter;
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:learn_english/features/object_detection/domain/entities/liveCamera.dart';
import 'package:learn_english/services/translation_text/LanguageTranslationService.dart';
import '../widget/TextOverlayPainter.dart';

class CameraPage extends StatefulWidget {
  final TextRecognitionScript script;
  const CameraPage({super.key, required this.script});


  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isReady = false;
  bool _isProcessing = false;
  Timer? _timer;
  DateTime? _lastScan;
  late TextRecognizer textRecognizer;
  List<CameraDescription> _cameras = [];
  int _sensorOrientation = 0;
  InputImageRotation? rotation;

  List<LiveCamera> _listLive = [];

  Size? _currentImageSize;
  InputImageRotation? _currentRotation;
  InputImageRotation? _currentRotationForStream;

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: widget.script);
    _initializeCamera();
  }
  @override
  void dispose() {
    _controller?.dispose();
    textRecognizer.close();
    _timer?.cancel();
    LanguageTranslationService.dispose();
    super.dispose();
  }


  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    final camera = _cameras.first;  // Back camera

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,  // Giữ nguyên
    );

    await _controller!.initialize();

    // _sensorOrientation = _cameras[0].sensorOrientation;
    // debugPrint("Sensor orientation: $_sensorOrientation");

    _controller!.startImageStream((CameraImage image) async {
      if (_isProcessing) return;

      final now = DateTime.now();
      if (_lastScan != null && now.difference(_lastScan!) < const Duration(milliseconds: 1000)) {  // Giảm xuống 1s cho smooth hơn
        return;
      }
      _lastScan = now;
      _isProcessing = true;

      List<LiveCamera> listLiveTMP = [];
      try {
        final inputImage = _convertCameraImage(image);
        if (inputImage == null) return;

        _currentImageSize = Size(image.width.toDouble(), image.height.toDouble());
        _currentRotation = _currentRotationForStream;

        final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);
        if (recognisedText.blocks.isNotEmpty) {
          final List<Future<LiveCamera>> futures = recognisedText.blocks.map((block) async {
            // Dùng non-blocking để tránh lag nếu model chưa ready
            final String translatedText = await LanguageTranslationService.translateToVietnamese(block.text);
            return LiveCamera(translatedText, block.boundingBox);
          }).toList();

          final List<LiveCamera> results = await Future.wait(futures);  // Await all parallel
          listLiveTMP = results;
        }
      } catch (e) {
        debugPrint("Lỗi OCR: $e");
      } finally {
        if (mounted) {
          setState(() {
            _currentImageSize = _currentImageSize;  // Gộp update size/rotation vào đây
            _currentRotation = _currentRotation;
            _listLive = listLiveTMP;
          });
        }
        _isProcessing = false;
      }
    });

    if (mounted) {
      setState(() {
        _isReady = true;
      });
    }
  }
  final Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _convertCameraImage(CameraImage image) {
    if (_controller == null || _cameras.isEmpty) return null;

    final camera = _cameras[0];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      final deviceOrientation = _controller!.value.deviceOrientation;
      final rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        var rotated = (sensorOrientation + rotationCompensation) % 360;
        rotation = InputImageRotationValue.fromRawValue(rotated);
        // debugPrint("Front rotated: $rotated");
      } else {
        var rotated = (sensorOrientation - rotationCompensation + 360) % 360;
        rotation = InputImageRotationValue.fromRawValue(rotated);
      }
    }
    if (rotation == null) return null;

    _currentRotationForStream = rotation;

    Uint8List? bytes;
    InputImageFormat format;
    int? bytesPerRow;

    if (Platform.isIOS) {
      bytes = image.planes[0].bytes;
      format = InputImageFormat.bgra8888;
      bytesPerRow = image.planes[0].bytesPerRow;
    } else {
      bytes = _yuv420ToNv21(image);
      format = InputImageFormat.nv21;
      bytesPerRow = image.width;
    }

    if (bytes==null) return null;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  Uint8List _yuv420ToNv21(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final ySize = width * height;
    final uvSize = (width * height) ~/ 2;
    final nv21 = Uint8List(ySize + uvSize);

    // Copy Y plane
    final yPlane = image.planes[0];
    int yPos = 0;
    for (int row = 0; row < height; row++) {
      final yRowStart = row * yPlane.bytesPerRow;
      nv21.setRange(yPos, yPos + width, yPlane.bytes.sublist(yRowStart, yRowStart + width));
      yPos += width;
    }

    // Interleave V + U for chroma (NV21 format)
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStrideU = uPlane.bytesPerPixel ?? 1;  // Thường 2
    final uvPixelStrideV = vPlane.bytesPerPixel ?? 1;  // Thường 1

    int uvPos = ySize;
    for (int row = 0; row < height ~/ 2; row++) {
      final uvRowStart = row * uvRowStride;
      for (int col = 0; col < width ~/ 2; col++) {
        // V trước, U sau
        final vOffset = uvRowStart + col * uvPixelStrideV;
        final uOffset = uvRowStart + col * uvPixelStrideU;
        nv21[uvPos++] = vPlane.bytes[vOffset];
        nv21[uvPos++] = uPlane.bytes[uOffset];
      }
    }

    return nv21;
  }

  Future<void> _captureScreenshot() async {
    if (!mounted) return;
    try {
      if (_controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }
      _isProcessing = false;

      // Capture ảnh gốc
      final XFile photo = await _controller!.takePicture();

      // Mở UI crop ngay
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cắt Ảnh',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cắt Ảnh',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) {
        return;
      }

      setState(() {
        _isReady = false;
      });

      final File imageFile = File(croppedFile.path);

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/imageObject',
            (route) => false,
        arguments: {'imageFile': imageFile},
      );

    } catch (e) {
      debugPrint('Lỗi capture/crop: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera")),
      body: _isReady && _controller != null ? Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: CameraPreview(_controller!),
          ),
          if (_listLive.isNotEmpty)
            CustomPaint(
              painter: BoxPainter(
                boxes: _listLive,
                imageSize: _currentImageSize ?? Size(0, 0), // Lưu image size vào state
                rotation: _currentRotation ?? InputImageRotation.rotation0deg,
                isFrontCamera: false,
                useBoxFitCover: true,
              ),
              size: Size.infinite, // Hoặc match preview size
            ),

          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: (){
                print("ấn capture");
                  _captureScreenshot();
                },  // Gọi hàm capture
                child: Icon(Icons.camera_alt)
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
