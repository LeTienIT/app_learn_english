import 'dart:io';

import '../entity/TextTranslationResult.dart';
import '../repository/ImageTextRepository.dart';

class ProcessImageAndTranslateUseCase {
  final ImageTextRepository repository;

  ProcessImageAndTranslateUseCase(this.repository);

  /// Thực hiện use case: Nhận diện và dịch từng dòng văn bản từ ảnh.
  ///
  /// [imageFile]: File ảnh.
  /// [targetLanguage]: Ngôn ngữ đích (ví dụ: 'vi' cho tiếng Việt).
  ///
  /// Trả về TextTranslationResult nếu thành công, hoặc throw Exception nếu thất bại.
  Future<TextTranslationResult> call(File imageFile, String targetLanguage, String modeTranslation) async {
    // Validate input cơ bản
    if (!imageFile.existsSync()) {
      throw Exception('File ảnh không tồn tại.');
    }
    if (targetLanguage.isEmpty) {
      throw Exception('Ngôn ngữ đích không hợp lệ.');
    }

    // Gọi repository để xử lý
    final result = await repository.processImageAndTranslate(imageFile, targetLanguage, modeTranslation);

    // Business logic: Kiểm tra xem có dòng văn bản nào không
    if (result.lines.isEmpty) {
      throw Exception('Không nhận diện được văn bản từ ảnh.');
    }

    return result;
  }
}