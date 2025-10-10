import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class ImageTextDataSource {
  /// Nhận diện văn bản từ ảnh và dịch từng dòng sang ngôn ngữ đích.
  ///
  /// [imageFile]: File ảnh đầu vào.
  /// [targetLanguage]: Mã ngôn ngữ đích (ví dụ: 'vi' cho tiếng Việt).
  ///
  /// Trả về Future<List<(String, String)>> chứa danh sách (văn bản gốc, văn bản dịch) cho từng dòng.
  /// Throw Exception nếu lỗi.
  Future<List<(String, String)>> processImageAndTranslate(File imageFile, String targetLanguage,String modeTranslation, TextRecognitionScript script);
}