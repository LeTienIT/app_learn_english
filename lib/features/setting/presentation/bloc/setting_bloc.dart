import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:learn_english/features/setting/presentation/bloc/setting_event.dart';
import 'package:learn_english/features/setting/presentation/bloc/setting_state.dart';

import '../../../../core/constants.dart';
import '../../../../core/helper.dart';
import '../../../../injection/injection.dart';
import '../../../../services/app_storage/share_preferences.dart';
import '../../../../services/tts/FlutterTtsService.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppStorageService storage;
  final modelManager = OnDeviceTranslatorModelManager();

  SettingsBloc(this.storage) : super(SettingsState.initial()) {
    // Load tất cả setting từ storage
    on<LoadSettings>((event, emit) async {
      final music = await storage.get<bool>(musicKey) ?? true;
      final volume = await storage.get<double>(volumeKey) ?? 0.5;
      final dark = await storage.get<bool>(darkModeKey) ?? false;
      final language = await storage.get<String>(languageCode) ?? 'en';

      final models = <LanguageModel>[];

      for (final lang in listLanguage) {
        final code = lang["code"]!;
        final name = lang["label"]!;

        bool downloaded = await modelManager.isModelDownloaded(code);
        models.add(LanguageModel(
          id: code,
          name: name,
          status: downloaded ? ModelStatus.downloaded : ModelStatus.notDownloaded,
        ));
      }

      emit(SettingsState(
        languageCode: language,
        musicEnabled: music,
        volume: volume,
        darkMode: dark,
        models: models,
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

    on<UpdateLanguage>((event, emit) async {
      await storage.save(languageCode, event.languageCode);
      emit(state.copyWith(languageCode: event.languageCode));

      final tts = sl<FlutterTtsService>();
      final locale = mapLanguageToLocale(event.languageCode);
      await tts.setLanguage(locale);
    });

    on<DownloadModel>(_onDownloadModel);
  }

  Future<void> _onDownloadModel(DownloadModel event, Emitter<SettingsState> emit) async {
    final updated = state.models.map((m) {
      if (m.id == event.languageCode) {
        return m.copyWith(status: ModelStatus.downloading);
      }
      return m;
    }).toList();
    emit(state.copyWith(models: updated));

    try {
      await modelManager.downloadModel(event.languageCode);
      final refreshed = state.models.map((m) {
        if (m.id == event.languageCode) {
          return m.copyWith(status: ModelStatus.downloaded);
        }
        return m;
      }).toList();
      emit(state.copyWith(models: refreshed));
    } catch (e) {
      final failed = state.models.map((m) {
        if (m.id == event.languageCode) {
          return m.copyWith(status: ModelStatus.notDownloaded);
        }
        return m;
      }).toList();
      emit(state.copyWith(models: failed));
    }
  }
}
