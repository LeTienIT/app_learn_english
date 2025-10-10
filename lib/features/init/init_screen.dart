import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'init_cubit.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InitCubit()..initializeApp(),
      child: BlocListener<InitCubit, bool>(
        listener: (context, done) {
          if (done) {
            Navigator.pushNamedAndRemoveUntil(context, "/imageObject", (router)=>false);
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  "Đang chuẩn bị dữ liệu",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
