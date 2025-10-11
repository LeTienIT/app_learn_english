import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection/injection.dart' as di;
import '../../../setting/presentation/bloc/setting_bloc.dart';
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
  final SettingsBloc settingsBloc;

  WordBloc({required this.addWord, required this.getAllWords, required this.updateWord, required this.deleteWord, required this.settingsBloc}) : super(WordInitial()) {
    on<LoadWords>(_onLoadWords);
    on<AddWordEvent>(_onAddWord);
    on<UpdateWordEvent>(_onUpdateWord);
    on<DeleteWordEvent>(_onDeleteWord);
  }

  Future<void> _onLoadWords(LoadWords event, Emitter<WordState> emit) async {
    emit(WordLoading());
    try
    {
      print("onload");
      final settings = settingsBloc.state;
      final words = await getAllWords(languageType: settings.languageCode);
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onAddWord(AddWordEvent event, Emitter<WordState> emit,) async {
    emit(WordLoading());
    try {
      final rs = await addWord(event.word);
      if(rs == -1){
        emit(WordError("Từ đã tồn tại, không thể thêm"));
      }else {
        emit(WordAddSuccess(event.word));
        final settings = settingsBloc.state;
        final words = await getAllWords(languageType: settings.languageCode);
        emit(WordLoaded(words));
      }
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onUpdateWord(UpdateWordEvent event, Emitter<WordState> emit,) async {
    emit(WordLoading());
    try {
      await updateWord(event.word);
      final settings = di.sl<SettingsBloc>().state;
      final words = await getAllWords(languageType: settings.languageCode);
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }

  Future<void> _onDeleteWord(DeleteWordEvent event, Emitter<WordState> emit,) async {
    emit(WordLoading());
    try {
      await deleteWord(event.word);
      final settings = settingsBloc.state;
      final words = await getAllWords(languageType: settings.languageCode);
      emit(WordLoaded(words));
    } catch (e) {
      emit(WordError(e.toString()));
    }
  }
}
