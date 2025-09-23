import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../injection/injection.dart' as di;
import '../../../../../services/speech_to_text/SpeechService.dart';
import '../../../../object_detection/domain/use_case/TextToSpeechUseCase.dart';
import '../../../domain/entities/word.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleFavorite;

  const WordItem({
    super.key,
    required this.word,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.onToggleFavorite,
  });

  Future<void> _showListeningDialog(BuildContext context, String target) async {
    String recognizedText = '';
    bool isListening = true;
    bool success = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            di.sl<SpeechToTextService>().startListening(
              onResult: (text) {
                setState(() {
                  recognizedText = text;
                  if(recognizedText.toLowerCase().trim() == target.toLowerCase().trim()){
                    success = true;
                    di.sl<SpeechToTextService>().stopListening();
                  }
                });
              },
            );

            // UI của dialog
            return AlertDialog(
              title: success ? const Text("Hoàn thành") : const Text("Đang lắng nghe..."),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  success ? SizedBox.shrink() : const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(recognizedText.isEmpty ? "Nói gì đó đi..." : recognizedText, style: const TextStyle(fontSize: 16),),
                  if(success)...[
                    Lottie.asset(
                      'assets/winner.json',
                      width: 150,
                      height: 150,
                      repeat: true,
                    ),
                    const Text("Hoàn thành"),
                  ]
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await di.sl<SpeechToTextService>().stopListening();
                    isListening = false;
                    Navigator.pop(context, recognizedText);
                  },
                  child: success ? const Text("Đóng") : const Text("Dừng"),
                )
              ],
            );
          },
        );
      },
    );

    if (isListening) {
      await di.sl<SpeechToTextService>().cancelListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(word.english), // key unique
      direction: onDelete != null ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (onDelete != null) {
          return await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Xóa từ"),
              content: Text("Bạn có chắc muốn xóa '${word.english}' không?"),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Xóa")),
              ],
            ),
          );
        }
        return false;
      },
      onDismissed: (_) {
        if (onDelete != null) onDelete!();
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onEdit,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              word.english,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              word.vietnamese,
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // để Row nhỏ gọn, không chiếm hết ListTile
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.blue),
                  onPressed: () {
                    di.sl<TextToSpeechUseCase>().call(word.english);
                  },
                  tooltip: 'Phát âm',
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.red),
                  onPressed: () {
                    if(di.sl<SpeechToTextService>().available){
                      _showListeningDialog(context,word.english);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ứng dụng không hỗ trợ lấy âm thanh"),backgroundColor: Colors.redAccent,));
                    }
                  },
                  tooltip: 'Lắng nghe',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
