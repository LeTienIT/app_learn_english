import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget{
  Widget childWidget;
  CardWidget({super.key, required this.childWidget});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: childWidget,
      ),
    );
  }
}