import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class ImageTranslationEvent {}

class TranslationEvent extends ImageTranslationEvent {
  final File imagePath;
  final String language;
  final String modeTranslation;
  final TextRecognitionScript script;

  TranslationEvent(this.imagePath, this.language, this.modeTranslation, this.script);
}