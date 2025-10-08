import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  const ImageViewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem ảnh chụp')),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          File(imagePath).delete();
          Navigator.pop(context);
        },
        child: const Icon(Icons.close),
      ),
    );
  }
}