import 'package:flutter/material.dart';

import '../../../injection/injection.dart' as di;
import '../../../services/music/audio_player.dart';
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
            icon: Icons.camera_alt,
            title: "Ống kính",
            onTap: (){
              di.sl<AudioPlayerService>().stopBackground();
              Navigator.pushNamedAndRemoveUntil(context, '/imageObject',(router)=>false);
            },
          ),
          AnimatedMenuItem(
            icon: Icons.menu_book,
            title: "Danh sách từ",
            onTap: () {
              di.sl<AudioPlayerService>().stopBackground();
              Navigator.pushNamedAndRemoveUntil(context, '/dictionary', (router) => false);
            },
          ),
          AnimatedMenuItem(
            icon: Icons.assignment_outlined,
            title: "Luyện tập",
            onTap: () {
              di.sl<AudioPlayerService>().stopBackground();
              Navigator.pushNamedAndRemoveUntil(context, '/quiz', (router) => false);
            },
          ),
          AnimatedMenuItem(
            icon: Icons.assignment_outlined,
              title: "Cài đặt",
            onTap: () {
              di.sl<AudioPlayerService>().stopBackground();
              Navigator.pushNamedAndRemoveUntil(context, '/setting', (router) => false);
            },
          ),
        ],
      ),
    );
  }

}