import 'package:flutter/material.dart';

class AddWordDialog extends StatefulWidget {
  final String initialEnglish;
  final String initialVietnamese;
  final void Function(String english, String vietnamese) onSave;

  const AddWordDialog({
    super.key,
    this.initialEnglish = '',
    this.initialVietnamese = '',
    required this.onSave,
  });

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  late TextEditingController englishController;
  late TextEditingController vietnameseController;

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
    return AlertDialog(
      title: const Text("Thêm từ mới"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: englishController,
            decoration: const InputDecoration(labelText: "English"),
          ),
          TextField(
            controller: vietnameseController,
            decoration: const InputDecoration(labelText: "Vietnamese"),
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
