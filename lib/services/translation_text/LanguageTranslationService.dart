import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageTranslationService {
  static final LanguageIdentifier _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  static final OnDeviceTranslatorModelManager _modelManager = OnDeviceTranslatorModelManager();

  static TranslateLanguage? _getTranslateLanguage(String bcpCode) {
    try {
      return TranslateLanguage.values.firstWhere((lang) => lang.bcpCode == bcpCode);
    } catch (e) {
      return null;
    }
  }

  /// Nhận diện ngôn ngữ và dịch văn bản sang tiếng Việt.
  /// Trả về Future<String> là bản dịch, hoặc lỗi nếu thất bại.
  static Future<String> translateToVietnamese(String text) async {
    if (text.isEmpty) {
      return '';
    }

    try {
      // Bước 1: Nhận diện ngôn ngữ
      final String sourceLanguage = await _languageIdentifier.identifyLanguage(text);

      if (sourceLanguage.isEmpty) {
        return text;
      }

      // Kiểm tra ngôn ngữ nguồn có hỗ trợ không
      final TranslateLanguage? sourceLang = _getTranslateLanguage(sourceLanguage);
      if (sourceLang == null) {
        return text;
      }

      // Bước 2: Tải model nếu cần
      if (!await _modelManager.isModelDownloaded(sourceLang.bcpCode)) {
        return text;
      }

      // Bước 3: Tạo translator
      final OnDeviceTranslator translator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: TranslateLanguage.vietnamese,
      );

      // Bước 4: Dịch văn bản
      final String translatedText = await translator.translateText(text);

      // Giải phóng translator
      translator.close();

      return translatedText;
    } catch (e) {
      throw Exception('Lỗi khi dịch: $e');
    }
  }

  /// Giải phóng tài nguyên (gọi khi app kết thúc nếu cần)
  static void dispose() {
    _languageIdentifier.close();
  }
}