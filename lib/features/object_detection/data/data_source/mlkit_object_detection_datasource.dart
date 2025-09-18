import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entity/DetectedLabel.dart';

class MlkitObjectDetectionDatasource {
  late final ObjectDetector _objectDetector;
  late final List<String> _labels;

  Future<void> init() async {
    final modelPath = await _getModelPath('assets/models/detect.tflite');

    // load label map
    final labelData = await rootBundle.loadString('assets/models/labelmap.txt');
    _labels = labelData.split('\n').where((e) => e.isNotEmpty).toList();

    _objectDetector = ObjectDetector(
        options: LocalObjectDetectorOptions(
        mode: DetectionMode.single,
        modelPath: modelPath, // Cập nhật đường dẫn
        classifyObjects: true,
        multipleObjects: true,
        maximumLabelsPerObject: 5,
        confidenceThreshold: 0.5,
    ),);

    debugPrint("✅ ML Kit Object Detector initialized");
  }

  Future<List<DetectedLabel>> detectObjects(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final objects = await _objectDetector.processImage(inputImage);

    final results = <DetectedLabel>[];

    for (final obj in objects) {
      for (final label in obj.labels) {
        // lấy index từ model -> ánh xạ sang nhãn trong labelmap.txt
        final labelName = (label.index != null && label.index! < _labels.length)
            ? _labels[label.index!]
            : "unknown";

        results.add(
          DetectedLabel(
            label: labelName,
            confidence: label.confidence,
          ),
        );
      }
    }

    return results;
  }

  Future<void> close() async {
    await _objectDetector.close();
  }

  Future<String> _getModelPath(String assetPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/${assetPath.split('/').last}');

    if (!await modelFile.exists()) {
      await modelFile.create(recursive: true);
      final byteData = await rootBundle.load(assetPath);
      await modelFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
    }
    return modelFile.path;
  }
}

