class SettingsState {
  final String languageCode;
  final bool musicEnabled;
  final double volume;
  final bool darkMode;
  final List<LanguageModel> models;

  const SettingsState({
    this.languageCode = 'en',
    required this.musicEnabled,
    required this.volume,
    required this.darkMode,
    this.models = const [],
  });

  SettingsState copyWith({
    String? languageCode,
    bool? musicEnabled,
    double? volume,
    bool? darkMode,
    List<LanguageModel>? models,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      volume: volume ?? this.volume,
      darkMode: darkMode ?? this.darkMode,
      models: models ?? this.models,
    );
  }

  factory SettingsState.initial() {
    return const SettingsState(
      languageCode : 'en',
      musicEnabled: true,
      volume: 0.5,
      darkMode: false,
      models : [],
    );
  }
}
enum ModelStatus { notDownloaded, downloading, downloaded }

class LanguageModel {
  final String id;
  final String name;
  final ModelStatus status;

  const LanguageModel({
    required this.id,
    required this.name,
    required this.status,
  });

  LanguageModel copyWith({
    String? id,
    String? name,
    ModelStatus? status,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}
