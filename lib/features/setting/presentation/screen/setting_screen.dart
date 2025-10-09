import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/shared/widget/menu.dart';

import '../../../../core/constants.dart';
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
              const Text(
                "Cài đặt ngôn ngữ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: state.languageCode,
                decoration: const InputDecoration(labelText: "Ngôn ngữ dịch"),
                items: const [
                  DropdownMenuItem(value: "en", child: Text("Tiếng Anh")),
                  DropdownMenuItem(value: "zh", child: Text("Tiếng Trung")),
                  DropdownMenuItem(value: "ja", child: Text("Tiếng Nhật")),
                  DropdownMenuItem(value: "vi", child: Text("Tiếng Việt")),
                  DropdownMenuItem(value: "ko", child: Text("Tiếng Hàn")),
                ],
                onChanged: (value) {
                  if(value!=null){
                    context.read<SettingsBloc>().add(UpdateLanguage(value));
                  }
                },
              ),
              const SizedBox(height: 10),
              ...listLanguage.map((lang) {
                final model = state.models.firstWhere((m) => m.id == lang["code"]);
                return ListTile(
                  leading: Icon(
                    model.status == ModelStatus.downloaded
                        ? Icons.check_circle
                        : model.status == ModelStatus.downloading
                        ? Icons.downloading
                        : Icons.download,
                    color: model.status == ModelStatus.downloaded
                        ? Colors.green
                        : model.status == ModelStatus.downloading
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  title: Text(model.name),
                  subtitle: Text(
                    model.status == ModelStatus.downloaded
                        ? "Đã tải"
                        : model.status == ModelStatus.downloading
                        ? "Đang tải..."
                        : "Chưa tải",
                  ),
                  trailing: switch (model.status) {
                    ModelStatus.downloaded => const SizedBox.shrink(),
                    ModelStatus.downloading => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    ModelStatus.notDownloaded => ElevatedButton(
                      onPressed: () {
                        context.read<SettingsBloc>().add(DownloadModel(model.id));
                      },
                      child: const Text("Tải"),
                    ),
                  },
                );
              }),

              const Divider(height: 32),
            ],
          );
        },
      ),
    );
  }
}
