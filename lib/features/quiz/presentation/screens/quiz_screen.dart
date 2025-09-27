// quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_english/features/quiz/presentation/widgets/card_widget.dart';
import 'package:learn_english/features/quiz/presentation/widgets/text_widget.dart';
import 'package:learn_english/features/shared/widget/menu.dart';

import '../../../../core/constants.dart';
import '../../../dictionary/presentation/bloc/word_bloc.dart';
import '../../../dictionary/presentation/bloc/word_state.dart';


class QuizScreen extends StatefulWidget {

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int soCauHoi = 10;
  String optionEx = "all";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Luyện tập"),centerTitle: true,),
      drawer: Drawer(child: MenuShare(),),
      body: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state is WordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is WordLoaded) {
            final filtered = state.words;
            if(filtered.isEmpty || filtered.length < requiredWord){
              return Padding(
                padding: EdgeInsets.all(20),
                child: RichText(text: TextSpan(
                    text: "Tính năng chỉ khả dụng khi số từ vựng lớn hơn hoặc bằng $requiredWord từ",
                    style: TextStyle(fontSize: 20,color: Colors.black),
                    children: [
                      TextSpan(
                          text: "\n\nSố từ vựng hiện tại: ${filtered.length}",
                          style: TextStyle(fontSize: 18,color: Colors.redAccent)
                      )
                    ]
                )),
              );

            }
            else if (filtered.length >= requiredWord) {
              return Container(
                width: double.infinity,
                color: Colors.white12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(height: 1,),
                    Text("Bạn có ${filtered.length} từ vựng. Có thể bắt đầu luyện tập!",textAlign: TextAlign.center, ),
                    SizedBox(height: 16),
                    CardWidget(
                        childWidget: Column(
                          children: [
                            TextTitleWidget("Chọn số từ luyện tập"),
                            SizedBox(height: 10,),
                            Center(
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  ...[5, 10, 20, 30].map((e) {
                                    return ChoiceChip(
                                      label: Text("$e câu"),
                                      selected: soCauHoi == e,
                                      onSelected: (val) {
                                        setState(() {
                                          soCauHoi = e;
                                        });
                                      },
                                      selectedColor: Colors.green,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    const SizedBox(height: 16),
                    CardWidget(
                        childWidget: Column(
                          children: [
                            TextTitleWidget("Chọn hình thức luyện tập"),
                            SizedBox(height: 10,),
                            Center(
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.center,
                                children: [
                                  ...["write","voice","all"].map((e) {
                                    return ChoiceChip(
                                      label: Text(showLabel(e)),
                                      selected: optionEx == e,
                                      onSelected: (val) {
                                        setState(() {
                                          optionEx = e;
                                        });
                                      },
                                      selectedColor: Colors.green,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/excercise',
                            (route) => false,
                            arguments: {
                              'numberQ': soCauHoi,
                              'typeQ': optionEx,
                            },);
                        },
                        child: const Text("Bắt đầu"),
                      ),
                    ),

                  ],
                ),
              );
            }
          }
          else if (state is WordError){
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Lỗi gì đó"));
        },
      ),
    );
  }

  String showLabel(String text){
    switch(text){
      case "write":
        return "Viết";
      case "voice":
        return "Đọc";
      case "all":
        return "Cả hai";
      default:
        return "KXĐ";
    }
  }
}
