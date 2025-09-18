import 'dart:io';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'image_text_datasource.dart';

class ImageTextDataSourceImpl implements ImageTextDataSource {

  TranslateLanguage _mapStringToTranslateLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'vi':
        return TranslateLanguage.vietnamese;
      case 'en':
        return TranslateLanguage.english;
      case 'fr':
        return TranslateLanguage.french;
      case 'ja':
        return TranslateLanguage.japanese;
      case 'zh':
        return TranslateLanguage.chinese;
      default:
        throw Exception('Ngôn ngữ không được hỗ trợ: $languageCode');
    }
  }

  @override
  Future<List<(String, String)>> processImageAndTranslate(File imageFile, String targetLanguage,String translationMode,) async {
    try {
      // Bước 1: Nhận diện văn bản từ ảnh
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      // Lấy danh sách các dòng văn bản
      final lines = <String>[];
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          lines.add(line.text);
        }
      }
      textRecognizer.close();

      if (lines.isEmpty) {
        throw Exception('Không nhận diện được văn bản từ ảnh.');
      }

      // Bước 2: Dịch từng dòng
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english, // Giả định ngôn ngữ nguồn
        targetLanguage: _mapStringToTranslateLanguage(targetLanguage),
      );

      final modelManager = OnDeviceTranslatorModelManager();
      final isModelDownloaded = await modelManager.isModelDownloaded(targetLanguage);
      if (!isModelDownloaded) {
        await modelManager.downloadModel(targetLanguage, isWifiRequired: false);
      }

      final result = <(String, String)>[];
      final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      if (translationMode == 'line') {
        // Translate by line (current behavior)
        for (var line in lines) {
          final detectedLanguage = await languageIdentifier.identifyLanguage(line);
          if(detectedLanguage!=targetLanguage){
            final translatedText = await translator.translateText(line);
            result.add((line, translatedText));
          }
        }
      } else {
        for (var line in lines) {
          // Split line into words, handling multiple spaces and punctuation
          final words = line.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
          for (var word in words) {
            final detectedLanguage = await languageIdentifier.identifyLanguage(word);
            if(detectedLanguage!=targetLanguage){
              final translatedText = await translator.translateText(word);
              result.add((word, translatedText));
            }
          }
        }
      }
      translator.close();

      return result;
    } catch (e) {
      throw Exception('Lỗi xử lý ảnh hoặc dịch văn bản: $e');
    }
  }
}