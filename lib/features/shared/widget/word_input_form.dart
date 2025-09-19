import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dictionary/domain/entities/word.dart';
import '../../dictionary/presentation/bloc/word_bloc.dart';
import '../../dictionary/presentation/bloc/word_event.dart';

class WordInputForm extends StatefulWidget {
  final String? initialEnglish;
  final String? initialVietnamese;
  final bool isEdit;
  final void Function(Word word) onSubmit;



  const WordInputForm({
    super.key,
    this.initialEnglish,
    this.initialVietnamese,
    this.isEdit = false,
    required this.onSubmit,
  });

  @override
  State<WordInputForm> createState() => _WordInputFormState();
}

class _WordInputFormState extends State<WordInputForm> {
  late final TextEditingController _englishController;
  late final TextEditingController _vietnameseController;

  @override
  void initState() {
    super.initState();
    _englishController = TextEditingController(text: widget.initialEnglish ?? "");
    _vietnameseController = TextEditingController(text: widget.initialVietnamese ?? "");
  }

  void _onSubmitPressed() {
    final english = _englishController.text.trim();
    final vietnamese = _vietnameseController.text.trim();

    if (english.isEmpty || vietnamese.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ English và Vietnamese")),
      );
      return;
    }

    final word = Word(
      english: english,
      vietnamese: vietnamese,
    );

    widget.onSubmit(word);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _englishController,
          decoration: const InputDecoration(
            labelText: "English",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _vietnameseController,
          decoration: const InputDecoration(
            labelText: "Vietnamese",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onSubmitPressed,
          child: Text(widget.isEdit ? "Update Word" : "Add Word"),
        ),
      ],
    );
  }
}
