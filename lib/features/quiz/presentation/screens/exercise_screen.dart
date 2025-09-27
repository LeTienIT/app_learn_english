import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../injection/injection.dart' as di;
import '../../../../services/speech_to_text/SpeechService.dart';
import '../../../object_detection/domain/use_case/TextToSpeechUseCase.dart';
import '../../domain/entities/quiz_question.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';

class ExerciseScreen extends StatefulWidget {
  final int numberQ;
  final String typeQ;
  const ExerciseScreen({super.key, this.numberQ=10, this.typeQ="all"});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String recognizedText = "Đang lắng nghe";
  bool? _lastMicActive;

  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(StartQuiz(numberOfQuestions: widget.numberQ, typeQ: widget.typeQ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Luyện tập"),
        centerTitle: true,
        elevation: 0, // tắt bóng để nhìn rõ line
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: BlocListener<QuizBloc, QuizState>(
        listenWhen: (previous, current) {
          return previous is QuizInProgress && current is QuizInProgress && previous.currentIndex != current.currentIndex;
        },
        listener: (context, state) {
          if (state is QuizInProgress) {
            di.sl<SpeechToTextService>().stopListening();
            setState(() {
              recognizedText = "";
            });
          }
          if (state is QuizFinished) {
            di.sl<SpeechToTextService>().stopListening();
          }
        },
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is QuizInProgress) {
              final q = state.questions[state.currentIndex];
              Widget questionWidget;
              if (q.type == QuizType.viToEn) {
                questionWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 1,),
                    Text("Dịch sang tiếng Anh: ${q.word.vietnamese}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true, // focus ngay khi render lần đầu
                      decoration: InputDecoration(
                        hintText: "Nhập câu trả lời...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (value) {
                        context.read<QuizBloc>().add(SubmitAnswer(value));
                        _controller.clear();
                        _focusNode.requestFocus(); // giữ focus để nhập tiếp
                      },
                    ),
                  ],
                );
              }
              else if (q.type == QuizType.enToVi) {
                questionWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 1,),
                    Text("Dịch sang tiếng Việt: ${q.word.english}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Nhập câu trả lời...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (value) {
                        context.read<QuizBloc>().add(SubmitAnswer(value));
                        _controller.clear();
                        _focusNode.requestFocus();
                      },
                    ),
                  ],
                );
              }
              else {
                questionWidget = Column(
                  children: [
                    Divider(height: 1,),
                    Text("Phát âm từ: ${q.word.english}"),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.volume_up, color: Colors.blue),
                            onPressed: () {
                              di.sl<TextToSpeechUseCase>().call(q.word.english);
                            },
                            tooltip: 'Phát âm',
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: di.sl<SpeechToTextService>().isMicActive,
                            builder: (context, isActive, _) {
                              if (_lastMicActive != null && _lastMicActive! && !isActive && q.type == QuizType.enSpeaking && state is QuizInProgress) {
                                // Mic vừa bị tắt
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Mic đã đóng - bật lại để tiếp tục"),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                });
                              }
                              _lastMicActive = isActive;

                              return IconButton(
                                icon: Icon(isActive ? Icons.mic_outlined : Icons.mic_off),
                                onPressed: () {
                                  if (isActive) {
                                    di.sl<SpeechToTextService>().stopListening();
                                  } else {
                                    di.sl<SpeechToTextService>().startListening(
                                      onResult: (text) {
                                        setState(() {
                                          recognizedText = text;
                                          context.read<QuizBloc>().add(SubmitAnswer(recognizedText));
                                        });
                                      },
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if(q.type == QuizType.enSpeaking)
                      Text(
                        recognizedText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Câu ${state.currentIndex + 1}/${state.questions.length}"),
                        Text("⏱ ${state.remainingSeconds}s"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    questionWidget,
                    const SizedBox(height: 10),
                    if (state.showFeedback)
                      Text(
                        (state.lastAnswerCorrect == true) ? "✅ Chính xác!" : "❌ Sai rồi",
                        style: TextStyle(
                          fontSize: 20,
                          color: (state.lastAnswerCorrect ?? false) ? Colors.green : Colors.red,
                        ),
                      ),
                  ],
                ),
              );
            }
            else if (state is QuizFinished) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/winner.json',
                        width: 150,
                        height: 150,
                        repeat: true,
                      ),
                      Text("Hoàn thành! Điểm: ${state.score}/${state.total}"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/quiz', (route) => false,);
                        },
                        child: const Text("Trở về"),
                      )
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

}
