// Entity cho kết quả nhận diện và dịch văn bản theo từng dòng
class TextLine {
  final String originalText; // Văn bản gốc của một dòng
  final String translatedText; // Văn bản dịch của một dòng

  const TextLine({
    required this.originalText,
    required this.translatedText,
  });

  @override
  String toString() {
    return 'TextLine(originalText: $originalText, translatedText: $translatedText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextLine &&
        other.originalText == originalText &&
        other.translatedText == translatedText;
  }

  @override
  int get hashCode => originalText.hashCode ^ translatedText.hashCode;
}

class TextTranslationResult {
  final List<TextLine> lines; // Danh sách các dòng văn bản
  final String targetLanguage; // Ngôn ngữ đích (ví dụ: 'vi' cho tiếng Việt)

  const TextTranslationResult({
    required this.lines,
    required this.targetLanguage,
  });

  // CopyWith để dễ dàng tạo bản sao với thay đổi
  TextTranslationResult copyWith({
    List<TextLine>? lines,
    String? targetLanguage,
  }) {
    return TextTranslationResult(
      lines: lines ?? this.lines,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }

  // toString cho debug
  @override
  String toString() {
    return 'TextTranslationResult(lines: $lines, targetLanguage: $targetLanguage)';
  }

  // equals và hashCode để so sánh
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextTranslationResult &&
        other.lines == lines &&
        other.targetLanguage == targetLanguage;
  }

  @override
  int get hashCode => lines.hashCode ^ targetLanguage.hashCode;
}