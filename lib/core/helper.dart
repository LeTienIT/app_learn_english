import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

String mapLanguageToLocale(String code) {
  switch (code) {
    case "zh": return "zh-CN";
    case "ja": return "ja-JP";
    case "vi": return "vi-VN";
    case "ko": return "ko-KR";
    default: return "en-US";
  }
}

TextRecognitionScript textScript(String languageCode){
  TextRecognitionScript script;
  switch (languageCode) {
    case 'zh': // Tiếng Trung
      script = TextRecognitionScript.chinese;
      break;
    case 'ja': // Tiếng Nhật
      script = TextRecognitionScript.japanese;
      break;
    case 'ko': // Tiếng Hàn
      script = TextRecognitionScript.korean;
      break;
    default: // Tiếng Anh, Việt...
      script = TextRecognitionScript.latin;
      break;
  }
  return script;
}

String textToCode(String languageCode){
  String script;
  switch (languageCode) {
    case 'zh': // Tiếng Trung
      script = "Trung";
      break;
    case 'ja': // Tiếng Nhật
      script = "Nhật";
      break;
    case 'ko': // Tiếng Hàn
      script = "Hàn";
      break;
    default: // Tiếng Anh, Việt...
      script = "Anh";
      break;
  }
  return script;
}