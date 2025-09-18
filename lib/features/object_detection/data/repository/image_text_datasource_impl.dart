import 'dart:io';
import '../../domain/entity/TextTranslationResult.dart';
import '../../domain/repository/ImageTextRepository.dart';
import '../data_source/image_text_datasource.dart';

class ImageTextRepositoryImpl implements ImageTextRepository {
  final ImageTextDataSource dataSource;

  ImageTextRepositoryImpl(this.dataSource);

  @override
  Future<TextTranslationResult> processImageAndTranslate(File imageFile, String targetLanguage,String modeTranslation) async {
    try {
      // Gọi DataSource để nhận diện và dịch
      final lineResults = await dataSource.processImageAndTranslate(
        imageFile,
        targetLanguage,
          modeTranslation,
      );

      // Ánh xạ kết quả thành danh sách TextLine
      final lines = lineResults
          .map((line) => TextLine(
        originalText: line.$1,
        translatedText: line.$2,
      ))
          .toList();

      // Trả về Entity
      return TextTranslationResult(
        lines: lines,
        targetLanguage: targetLanguage,
      );
    } catch (e) {
      throw Exception('Lỗi từ repository: $e');
    }
  }
}