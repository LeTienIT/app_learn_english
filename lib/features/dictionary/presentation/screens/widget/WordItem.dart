import 'package:flutter/material.dart';

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
            trailing: IconButton(
              icon: Icon(
                word.favorite ? Icons.star : Icons.star_border,
                color: word.favorite ? Colors.amber : Colors.grey,
              ),
              onPressed: onToggleFavorite,
            ),
          ),
        ),
      ),
    );
  }
}
