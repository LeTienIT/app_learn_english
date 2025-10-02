class SettingsState {
  final bool musicEnabled;
  final double volume;
  final bool darkMode;

  const SettingsState({
    required this.musicEnabled,
    required this.volume,
    required this.darkMode,
  });

  SettingsState copyWith({
    bool? musicEnabled,
    double? volume,
    bool? darkMode,
  }) {
    return SettingsState(
      musicEnabled: musicEnabled ?? this.musicEnabled,
      volume: volume ?? this.volume,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  factory SettingsState.initial() {
    return const SettingsState(
      musicEnabled: true,
      volume: 0.5,
      darkMode: false,
    );
  }
}
