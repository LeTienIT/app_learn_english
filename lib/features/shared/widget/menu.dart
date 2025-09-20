import 'package:flutter/material.dart';

class MenuShare extends StatefulWidget{
  const MenuShare({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenuShare();
  }

}
class _MenuShare extends State<MenuShare>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text("Menu", style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: const Text("Danh sách từ"),
          onTap: (){
            Navigator.pushNamedAndRemoveUntil(context, '/dictionary', (route) => false);
          },
        ),
        SizedBox(height: 10,),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Quét ảnh"),
          onTap: (){
            Navigator.pushNamedAndRemoveUntil(context, '/imageObject', (route) => false);
          },
        ),
      ],
    );
  }

}