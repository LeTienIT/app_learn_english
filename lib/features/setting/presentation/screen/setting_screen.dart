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
      appBar: AppBar(title: const Text("Cài đặt"),centerTitle: true,),
      drawer: Drawer(child: MenuShare(),),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Divider(height: 1,),
              SwitchListTile(
                title: const Text("Bật nhạc nền"),
                value: state.musicEnabled,
                onChanged: (value) {
                  value = !value;
                  context.read<SettingsBloc>().add(UpdateMusicEnabled(!value));
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ngôn ngữ hệ thống",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Chọn ngôn ngữ mặc định cho việc dịch, đọc văn bản và nhận diện từ ảnh.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: state.languageCode,
                      decoration: InputDecoration(
                        labelText: "Ngôn ngữ dịch",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      items: const [
                        DropdownMenuItem(value: "en", child: Text("🇬🇧  Tiếng Anh")),
                        DropdownMenuItem(value: "zh", child: Text("🇨🇳  Tiếng Trung")),
                        DropdownMenuItem(value: "ja", child: Text("🇯🇵  Tiếng Nhật")),
                        DropdownMenuItem(value: "vi", child: Text("🇻🇳  Tiếng Việt")),
                        DropdownMenuItem(value: "ko", child: Text("🇰🇷  Tiếng Hàn")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsBloc>().add(UpdateLanguage(value));
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...listLanguage.map((lang) {
                final model = state.models.firstWhere((m) => m.id == lang["code"]);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        size: 28,
                      ),
                      title: Text(
                        model.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            switch (model.id) {
                              "en" => "Gói dữ liệu để dịch tiếng Anh sang tiếng Việt.",
                              "zh" => "Gói dữ liệu để dịch tiếng Trung sang tiếng Việt.",
                              "ja" => "Gói dữ liệu để dịch tiếng Nhật sang tiếng Việt.",
                              "ko" => "Gói dữ liệu để dịch tiếng Hàn sang tiếng Việt.",
                              "vi" => "Gói dữ liệu ngôn ngữ tiếng Việt (mặc định).",
                              _ => "Gói dữ liệu hỗ trợ dịch ngôn ngữ.",
                            },
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            model.status == ModelStatus.downloaded
                                ? "✅ Đã tải về thiết bị"
                                : model.status == ModelStatus.downloading
                                ? "⏳ Đang tải..."
                                : "📦 Chưa tải",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: model.status == ModelStatus.downloaded
                                  ? Colors.green
                                  : model.status == ModelStatus.downloading
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: switch (model.status) {
                        ModelStatus.downloaded => const SizedBox.shrink(),
                        ModelStatus.downloading => const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        ModelStatus.notDownloaded => ElevatedButton.icon(
                          onPressed: () {
                            context.read<SettingsBloc>().add(DownloadModel(model.id));
                          },
                          icon: const Icon(Icons.download, size: 16),
                          label: const Text("Tải"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
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
