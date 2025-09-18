import '../../domain/entity/TextTranslationResult.dart';

abstract class ImageTranslationState {}

class ImageTranslationInitial extends ImageTranslationState {}

class ImageTranslationLoading extends ImageTranslationState {}

class ImageTranslationSuccess extends ImageTranslationState {
  final TextTranslationResult result; // Chỉ chứa một TextTranslationResult
  ImageTranslationSuccess(this.result);
}

class ImageTranslationFailure extends ImageTranslationState {
  final String message;
  ImageTranslationFailure(this.message);
}