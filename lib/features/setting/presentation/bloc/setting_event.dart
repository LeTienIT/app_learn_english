abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateMusicEnabled extends SettingsEvent {
  final bool enabled;
  UpdateMusicEnabled(this.enabled);
}

class UpdateVolume extends SettingsEvent {
  final double volume;
  UpdateVolume(this.volume);
}

class UpdateDarkMode extends SettingsEvent {
  final bool enabled;
  UpdateDarkMode(this.enabled);
}

class UpdateLanguage extends SettingsEvent{
  String languageCode;
  UpdateLanguage(this.languageCode);
}

class DownloadModel extends SettingsEvent {
  final String languageCode;
  DownloadModel(this.languageCode);
}