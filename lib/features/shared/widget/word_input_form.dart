import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/setting/presentation/bloc/setting_bloc.dart';

import '../../../core/helper.dart';

class AddWordDialog extends StatefulWidget {
  final String initialEnglish;
  final String initialVietnamese;
  final String? initLanguageType;
  final void Function(String english, String vietnamese) onSave;
  final bool add;

  const AddWordDialog({
    super.key,
    this.initialEnglish = '',
    this.initialVietnamese = '',
    this.initLanguageType,
    required this.onSave,
    this.add = true
  });

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  late TextEditingController englishController;
  late TextEditingController vietnameseController;
  late TextEditingController languageType;

  @override
  void initState() {
    super.initState();
    englishController = TextEditingController(text: widget.initialEnglish);
    vietnameseController = TextEditingController(text: widget.initialVietnamese);
  }

  @override
  void dispose() {
    englishController.dispose();
    vietnameseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsBloc>().state;
    String langType = '';
    if(widget.initLanguageType!=null){
      langType = textToCode(widget.initLanguageType!);
      languageType = TextEditingController(text: 'Tiếng: $langType');
    }
    else{
      langType = textToCode(settings.languageCode);
      languageType = TextEditingController(text: 'Tiếng: $langType');
    }
    return AlertDialog(
      title: Text(widget.add ? "Thêm từ mới" : "Chỉnh sửa"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: englishController,
            decoration: InputDecoration(labelText: 'Tiếng $langType'),
          ),
          TextField(
            controller: vietnameseController,
            decoration: const InputDecoration(labelText: "Tiếng Việt"),
          ),
          TextField(
            controller: languageType,
            decoration: const InputDecoration(labelText: "Loại"),
            readOnly: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () {
            final english = englishController.text.trim();
            final vn = vietnameseController.text.trim();

            if(english.isEmpty || vn.isEmpty){
              showDialog(context: context, builder: (_){
                return AlertDialog(
                  title: const Text("Lỗi"),
                  content: const Text("Không được để trống"),
                  actions: [
                    TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Ok")),
                  ],
                );
              });
            }
            else{
              widget.onSave(
                englishController.text.trim(),
                vietnameseController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}
