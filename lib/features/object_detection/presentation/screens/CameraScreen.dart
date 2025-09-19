import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_bloc.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_state.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/object_detection_event.dart';
import '../../../dictionary/presentation/bloc/word_bloc.dart';
import '../../../dictionary/presentation/bloc/word_event.dart';
import '../../../shared/widget/word_input_form.dart';
import '../../domain/use_case/PickAndCropImageUseCase.dart';
import '../../domain/use_case/TextToSpeechUseCase.dart';
import '../bloc/image_translation_event.dart';
import '../bloc/object_detection_bloc.dart';
import '../bloc/object_detection_state.dart';

import 'package:learn_english/injection/injection.dart' as di;

class ObjectDetectionPage extends StatefulWidget {
  const ObjectDetectionPage({super.key});

  @override
  State<ObjectDetectionPage> createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _imageFile;
  final ttsUseCase = di.sl<TextToSpeechUseCase>();

  @override
  void initState() {
    super.initState();
  }

  void _showAddWordDialog(BuildContext context, {String? english, String? vietnamese, bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? "Edit Word" : "Add Word"),
          content: WordInputForm(
            initialEnglish: english,
            initialVietnamese: vietnamese,
            isEdit: isEdit,
            onSubmit: (word) {
              Navigator.of(context).pop(); // đóng popup
              context.read<WordBloc>().add(AddWordEvent(word));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhận diên & dịch"),centerTitle: true,),
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
              onPressed: () async {
                final useCase = di.sl<PickAndCropImageUseCase>();

                try {
                  final file = await useCase();
                  if (file != null && mounted) {
                    setState(() => _imageFile = file);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi crop ảnh: $e')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Chụp ảnh"),
            ),

            SizedBox(height: 10,),
            Divider(height: 1,),
            SizedBox(height: 10,),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                    onPressed: (){
                      // context.read<ObjectDetectionBloc>().add(DetectObjectsEvent(_imageFile!));
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text("Thông báo"),
                              content: const Text("Tính năng đang trong quá trình phát triển!"),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  }, 
                                  child: const Text('Đóng')
                                )
                              ],
                            );
                          }
                      );
                    },
                    child: Text('Vật thể')),
                ElevatedButton(
                    onPressed: (){
                      if (_imageFile != null) {
                        context.read<ImageTranslationBloc>().add(TranslationEvent(File(_imageFile!.path), 'vi','line'),);
                      }
                    },
                    child: Text('Từng dòng')),
                ElevatedButton(
                    onPressed: (){
                      if (_imageFile != null) {
                        context.read<ImageTranslationBloc>().add(TranslationEvent(File(_imageFile!.path), 'vi','word'),);
                      }
                    },
                    child: Text('Từng từ')),
              ],
            ),
            SizedBox(height: 10,),
            // BlocBuilder<ObjectDetectionBloc, ObjectDetectionState>(
            //   builder: (context, state) {
            //     if (state is ObjectDetectionInitial) {
            //       return const Text("Chưa có dữ liệu nhận diện.");
            //     }
            //
            //     if (state is ObjectDetectionLoading) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //
            //     if (state is ObjectDetectionSuccess) {
            //       return Column(
            //         children: state.labels.map((e) {
            //           return Text("${e.label} - ${(e.confidence * 100).toStringAsFixed(1)}%");
            //         }).toList(),
            //       );
            //     }
            //
            //     if (state is ObjectDetectionFailure) {
            //       return Text(
            //         "Lỗi: ${state.message}",
            //         style: const TextStyle(color: Colors.red),
            //       );
            //     }
            //
            //     return const SizedBox.shrink();
            //   },
            // ),
            BlocBuilder<ImageTranslationBloc, ImageTranslationState>(
              builder: (context, state){
                if (state is ImageTranslationInitial) {
                  return const Center(child: Text('Chọn ảnh để bắt đầu'));
                } else if (state is ImageTranslationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ImageTranslationSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          'Kết quả',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      ...state.result.lines.asMap().entries.map((entry) {
                        final index = entry.key;
                        final line = entry.value;
                        return Column(
                          children: [
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                title: Text(
                                  'English: ${line.originalText}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue, // Màu chữ cho bản gốc
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Việt: ${line.translatedText}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic, // Chữ nghiêng cho bản dịch
                                      color: Colors.green[700], // Màu chữ cho bản dịch
                                    ),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.volume_up, color: Colors.blue),
                                      onPressed: () {
                                        ttsUseCase.call(line.originalText);
                                      },
                                      tooltip: 'Phát âm',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.save, color: Colors.green),
                                      onPressed: () {
                                        _showAddWordDialog(context, english: line.originalText, vietnamese: line.translatedText, isEdit: false);
                                      },
                                      tooltip: 'Lưu',
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if (index < state.result.lines.length - 1)
                              const Divider(
                                height: 1,
                                indent: 16.0,
                                endIndent: 16.0,
                              ),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                } else {
                  return const Center(child: Text('Có lỗi xảy ra'));
                }
              }
            ),
          ],
        ),
      )
    );
  }
}
