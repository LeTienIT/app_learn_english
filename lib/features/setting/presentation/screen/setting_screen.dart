import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/shared/widget/menu.dart';

import '../bloc/setting_bloc.dart';
import '../bloc/setting_event.dart';
import '../bloc/setting_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"),centerTitle: true,),
      drawer: Drawer(child: MenuShare(),),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Divider(height: 1,),
              // bật/tắt nhạc nền
              SwitchListTile(
                title: const Text("Bật nhạc nền"),
                value: state.musicEnabled,
                onChanged: (value) {
                  print(value);
                  value = !value;
                  print(value);
                  context.read<SettingsBloc>().add(UpdateMusicEnabled(!value));
                },
              ),

              const SizedBox(height: 20),

              // chỉnh âm lượng
              Text("Âm lượng: ${(state.volume * 100).round()}%"),
              Slider(
                value: state.volume,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(UpdateVolume(value));
                },
                min: 0,
                max: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
