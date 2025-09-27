import 'package:flutter/material.dart';

import 'animated_menu_item.dart';

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
    return Padding(
      padding: EdgeInsets.only(top: 28),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Menu", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Divider(height: 1),
          AnimatedMenuItem(
            icon: Icons.menu_book,
            title: "Danh sách từ",
            onTap: () => Navigator.pushNamed(context, '/dictionary'),
          ),
          AnimatedMenuItem(
            icon: Icons.camera_alt,
            title: "Quét ảnh",
            onTap: () => Navigator.pushNamed(context, '/imageObject'),
          ),
          AnimatedMenuItem(
            icon: Icons.assignment_outlined,
            title: "Luyện tập",
            onTap: () => Navigator.pushNamed(context, '/quiz'),
          ),
        ],
      ),
    );
  }

}