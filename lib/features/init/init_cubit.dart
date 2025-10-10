import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class InitCubit extends Cubit<bool> {
  final ModelManager modelManager = OnDeviceTranslatorModelManager();

  InitCubit() : super(false);

  Future<void> initializeApp() async {
    final langs = ["en", "vi"];

    for (final code in langs) {
      final downloaded = await modelManager.isModelDownloaded(code);
      if (!downloaded) {
        await modelManager.downloadModel(code);
      }
    }

    emit(true); // báo hoàn tất
  }
}
