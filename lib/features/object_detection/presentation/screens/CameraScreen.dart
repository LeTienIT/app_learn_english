import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/object_detection_event.dart';

import '../bloc/object_detection_bloc.dart';
import '../bloc/object_detection_state.dart';

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _imageFile;

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    try {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Ảnh',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Ảnh',
            aspectRatioLockEnabled: false,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi crop ảnh: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Object Detection Demo")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200, fit: BoxFit.cover,)
            else
              const Text("Chưa có ảnh nào"),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickAndCropImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Chụp ảnh"),
            ),

            Divider(height: 1,),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: (){
                      context.read<ObjectDetectionBloc>().add(DetectObjectsEvent(_imageFile!));
                    },
                    child: Text('Nhận diện vật thể')),
                ElevatedButton(
                    onPressed: (){

                    },
                    child: Text('Nhận diện chữ')),
              ],
            ),

            BlocBuilder<ObjectDetectionBloc, ObjectDetectionState>(
              builder: (context, state) {
                if (state is ObjectDetectionInitial) {
                  return const Text("Chưa có dữ liệu nhận diện.");
                }

                if (state is ObjectDetectionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ObjectDetectionSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kết quả nhận diện:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ...state.labels.map((label) => Text("• $label")).toList(),
                    ],
                  );
                }

                if (state is ObjectDetectionFailure) {
                  return Text(
                    "Lỗi: ${state.message}",
                    style: const TextStyle(color: Colors.red),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          ],
        ),
      )
    );
  }
}
