import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entity/DetectedLabel.dart';

class MlkitObjectDetectionDatasource {
  late final ObjectDetector _objectDetector;

  MlkitObjectDetectionDatasource() {
  }

  Future<void> init() async {
    final modelPath = await getModelPath('assets/models/ssd_mobilenet_v2_fpnlite.tflite');
    print("load xong");
    _objectDetector = ObjectDetector(
      options: LocalObjectDetectorOptions(
        mode: DetectionMode.single,
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: true,
        maximumLabelsPerObject: 5,
        confidenceThreshold: 0.5,
      ),
    );
  }

  Future<List<DetectedLabel>> detectObjects(File imagePath) async {
    final inputImage = InputImage.fromFile(imagePath);
    final objects = await _objectDetector.processImage(inputImage);
    print("Detected ${objects.length} objects: $objects");
    final results = <DetectedLabel>[];

    for (final obj in objects) {
      print("Object: BoundingBox=${obj.boundingBox}, Labels=${obj.labels}, TrackingID=${obj.trackingId}");
      for (final label in obj.labels) {
        results.add(
          DetectedLabel(
            label: label.text,
            confidence: label.confidence,
          ),
        );
      }
    }

    return results;
  }

  Future<void> close() async {
    _objectDetector.close();
  }

  Future<String> getModelPath(String assetPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/$assetPath');

    if (!await modelFile.exists()) {
      // ensure subdir
      await modelFile.parent.create(recursive: true);
      final byteData = await rootBundle.load(assetPath);
      await modelFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        flush: true,
      );
    }
    return modelFile.path;
  }
}
