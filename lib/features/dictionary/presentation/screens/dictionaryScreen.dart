import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/dictionary/presentation/screens/widget/WordItem.dart';
import 'package:learn_english/features/shared/widget/menu.dart';

import '../../../shared/widget/word_input_form.dart';
import '../../domain/entities/word.dart';
import '../bloc/word_bloc.dart';
import '../bloc/word_event.dart';
import '../bloc/word_state.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách từ"),centerTitle: true,),
      drawer: Drawer(child: MenuShare(),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Tìm từ...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value.toLowerCase();
                });
              },
            ),
          ),

          // danh sách từ
          Expanded(
            child: BlocBuilder<WordBloc, WordState>(
              builder: (context, state) {
                if (state is WordLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (state is WordLoaded) {
                  final filtered = state.words.where((word) {
                    return word.english.toLowerCase().contains(query) || word.vietnamese.toLowerCase().contains(query);
                  }).toList();
                  if (filtered.isEmpty) {
                    return const Center(child: Text("Không tìm thấy từ nào"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final word = filtered[index];
                      return WordItem(
                        word: word,
                        onDelete: () {
                          context.read<WordBloc>().add(DeleteWordEvent(word));
                        },
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddWordDialog(
                              initialEnglish: word.english,
                              initialVietnamese: word.vietnamese,
                              onSave: (en, vi) {
                                context.read<WordBloc>().add(UpdateWordEvent(
                                  Word(
                                      id: word.id,
                                      english: en,
                                      vietnamese: vi,
                                      example: word.example,
                                      favorite: word.favorite
                                  ),
                                ));
                              },
                            ),
                          );
                        },
                        onToggleFavorite: () {
                          context.read<WordBloc>().add(UpdateWordEvent(
                            Word(
                              id: word.id,
                              english: word.english,
                              vietnamese: word.vietnamese,
                              example: word.example,
                              favorite: !word.favorite,
                            ),
                          ));
                        },
                      );
                    },
                  );
                }
                else if (state is WordError){
                  return Center(child: Text(state.message));
                }
                else {
                  return const Center(child: Text("Danh sách trống"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
