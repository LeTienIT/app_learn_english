import 'dart:io';

abstract class ImageTranslationEvent {}

class TranslationEvent extends ImageTranslationEvent {
  final File imagePath;
  final String language;
  final String modeTranslation;

  TranslationEvent(this.imagePath, this.language, this.modeTranslation);
}