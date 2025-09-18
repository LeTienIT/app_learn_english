import 'dart:io';
import '../entity/TextTranslationResult.dart';

abstract class ImageTextRepository {
  /// Xử lý ảnh: nhận diện văn bản và dịch từng dòng sang ngôn ngữ đích.
  ///
  /// [imageFile]: File ảnh đầu vào.
  /// [targetLanguage]: Mã ngôn ngữ đích (ví dụ: 'vi' cho tiếng Việt).
  ///
  /// Trả về Future<TextTranslationResult> chứa danh sách dòng đã dịch.
  /// Throw Exception nếu lỗi.
  Future<TextTranslationResult> processImageAndTranslate(File imageFile, String targetLanguage,String modeTranslation);
}