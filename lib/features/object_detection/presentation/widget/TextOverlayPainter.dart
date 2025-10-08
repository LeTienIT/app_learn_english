import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../domain/entities/liveCamera.dart';

class BoxPainter extends CustomPainter {
  final List<LiveCamera> boxes;
  final Size imageSize;
  final InputImageRotation rotation;
  final bool isFrontCamera;
  final bool useBoxFitCover;

  BoxPainter({
    required this.boxes,
    required this.imageSize,
    required this.rotation,
    this.isFrontCamera = false,
    this.useBoxFitCover = true,
  });

  int _rotationToDegrees(InputImageRotation r) {
    switch (r) {
      case InputImageRotation.rotation90deg:
        return 90;
      case InputImageRotation.rotation180deg:
        return 180;
      case InputImageRotation.rotation270deg:
        return 270;
      case InputImageRotation.rotation0deg:
      default:
        return 0;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paintBorder = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final paintFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // final degrees = _rotationToDegrees(rotation);

    final degrees = _rotationToDegrees(rotation);
    // debugPrint("Painter input: previewSize=$size, degrees=$degrees");

    final rotatedImageSize = (degrees == 90 || degrees == 270)
        ? Size(imageSize.height, imageSize.width)
        : imageSize;

    final scale = useBoxFitCover
        ? max(size.width / rotatedImageSize.width, size.height / rotatedImageSize.height)
        : min(size.width / rotatedImageSize.width, size.height / rotatedImageSize.height);

    final adjustedW = rotatedImageSize.width * scale;
    final adjustedH = rotatedImageSize.height * scale;

    final offsetX = (size.width - adjustedW) / 2;
    final offsetY = (size.height - adjustedH) / 2;

    // debugPrint('BoxPainter debug: imageSize=$imageSize, rotated=$rotatedImageSize, degrees=$degrees, scale=$scale, adjusted=(${adjustedW.toStringAsFixed(1)}, ${adjustedH.toStringAsFixed(1)}), offset=(${offsetX.toStringAsFixed(1)}, ${offsetY.toStringAsFixed(1)})');

    for (final rawBox in boxes) {
      Rect fixedBox = rawBox.box;
      if (isFrontCamera) {
        fixedBox = Rect.fromLTRB(
          rotatedImageSize.width - rawBox.box.right,
          rawBox.box.top,
          rotatedImageSize.width - rawBox.box.left,
          rawBox.box.bottom,
        );
      }

      final normLeft = fixedBox.left / rotatedImageSize.width;
      final normTop = fixedBox.top / rotatedImageSize.height;
      final normRight = fixedBox.right / rotatedImageSize.width;
      final normBottom = fixedBox.bottom / rotatedImageSize.height;

      // debugPrint("Norm values: left=$normLeft, top=$normTop, right=$normRight, bottom=$normBottom");

      var left = normLeft * adjustedW + offsetX;
      var top = normTop * adjustedH + offsetY;
      var width = (normRight - normLeft) * adjustedW;
      var height = (normBottom - normTop) * adjustedH;

      // Clamp (giữ tạm, bỏ sau khi rotation ok)
      if (left < 0) {
        width += left;
        left = 0;
      }
      if (left + width > size.width) {
        width = size.width - left;
      }
      if (top < 0) {
        height += top;
        top = 0;
      }
      if (top + height > size.height) {
        height = size.height - top;
      }

      final drawRect = Rect.fromLTWH(left, top, width, height);

      // debugPrint('rawBox=$rawBox -> fixedBox=$fixedBox -> draw (clamped)=$drawRect');

      if (drawRect.width > 0 && drawRect.height > 0) {
        canvas.drawRect(drawRect, paintFill);
        canvas.drawRect(drawRect, paintBorder);

        final text = rawBox.textView;
        final textSpan = TextSpan(
          text: text,
          style: TextStyle(color: Colors.black, fontSize: 11),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: drawRect.width - 8); // trừ margin nhỏ
        textPainter.paint(canvas, Offset(drawRect.left + 4, drawRect.top + 4));

      }
    }
  }

  @override
  bool shouldRepaint(covariant BoxPainter oldDelegate) {
    return oldDelegate.boxes != boxes ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.rotation != rotation ||
        oldDelegate.isFrontCamera != isFrontCamera ||
        oldDelegate.useBoxFitCover != useBoxFitCover;
  }
}