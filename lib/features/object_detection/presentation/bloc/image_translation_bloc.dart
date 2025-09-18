import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_event.dart';
import 'package:learn_english/features/object_detection/presentation/bloc/image_translation_state.dart';
import '../../domain/entity/TextTranslationResult.dart';
import '../../domain/use_case/TranslateUseCase.dart';

class ImageTranslationBloc extends Bloc<ImageTranslationEvent, ImageTranslationState> {
  final ProcessImageAndTranslateUseCase imageAndTranslateUseCase;

  ImageTranslationBloc(this.imageAndTranslateUseCase) : super(ImageTranslationInitial()) {
    on<TranslationEvent>(_onImageTranslation);
  }

  Future<void> _onImageTranslation(TranslationEvent event, Emitter<ImageTranslationState> emit,) async {
    emit(ImageTranslationLoading());
    try {
      final TextTranslationResult result = await imageAndTranslateUseCase.call(
        event.imagePath,
        event.language,
        event.modeTranslation
      );
      emit(ImageTranslationSuccess(result));
    } catch (e) {
      emit(ImageTranslationFailure('Lỗi: ${e.toString()}'));
    }
  }
}
