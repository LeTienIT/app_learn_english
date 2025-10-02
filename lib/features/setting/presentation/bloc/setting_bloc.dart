import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/setting/presentation/bloc/setting_event.dart';
import 'package:learn_english/features/setting/presentation/bloc/setting_state.dart';

import '../../../../core/constants.dart';
import '../../../../services/app_storage/share_preferences.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppStorageService storage;

  SettingsBloc(this.storage) : super(SettingsState.initial()) {
    // Load tất cả setting từ storage
    on<LoadSettings>((event, emit) async {
      final music = await storage.get<bool>(musicKey) ?? true;
      print("music: $music");
      final volume = await storage.get<double>(volumeKey) ?? 0.5;
      final dark = await storage.get<bool>(darkModeKey) ?? false;

      emit(SettingsState(
        musicEnabled: music,
        volume: volume,
        darkMode: dark,
      ));
    });

    // Update music
    on<UpdateMusicEnabled>((event, emit) async {
      await storage.save(musicKey, event.enabled);
      emit(state.copyWith(musicEnabled: event.enabled));
    });

    // Update volume
    on<UpdateVolume>((event, emit) async {
      await storage.save(volumeKey, event.volume);
      emit(state.copyWith(volume: event.volume));
    });

    // Update dark mode
    on<UpdateDarkMode>((event, emit) async {
      await storage.save(darkModeKey, event.enabled);
      emit(state.copyWith(darkMode: event.enabled));
    });
  }
}
