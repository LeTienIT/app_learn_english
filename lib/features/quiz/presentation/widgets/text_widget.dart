import 'package:flutter/material.dart';

class TextTitleWidget extends StatelessWidget{
  String text;

  TextTitleWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87,),);
  }
}