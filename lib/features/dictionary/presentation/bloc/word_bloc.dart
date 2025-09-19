import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_case/add_word.dart';
import '../../domain/use_case/delete_word.dart';
import '../../domain/use_case/get_all_word.dart';
import '../../domain/use_case/update_word.dart';
import 'word_event.dart';
import 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final AddWord addWord;
  final GetAllWords getAllWords;
  final UpdateWord updateWord;
  final DeleteWord deleteWord;

  WordBloc({required this.addWord, required this.getAllWords, required this.updateWord, required this.deleteWord,}) : super(WordInitial()) {
    on<LoadWords>(_onLoadWords);
    on<AddWordEvent>(_onAddWord);
    on<UpdateWordEvent>(_onUpdateWord);
    on<DeleteWordEvent>(_onDeleteWord);
  }

  Future<void> _onLoadWords(LoadWords event, Emitter<WordState> emit,) async {
    emit(WordLoading());
    try {
      final words = await getAllWords();
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onAddWord(AddWordEvent event, Emitter<WordState> emit,) async {
    try {
      final rs = await addWord(event.word);
      print("Thêm word: $rs");
      final words = await getAllWords();
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onUpdateWord(UpdateWordEvent event, Emitter<WordState> emit,) async {
    try {
      await updateWord(event.word);
      final words = await getAllWords();
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onDeleteWord(DeleteWordEvent event, Emitter<WordState> emit,) async {
    try {
      await deleteWord(event.word);
      final words = await getAllWords();
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }
}
