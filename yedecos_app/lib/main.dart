import 'package:flutter/material.dart';
import 'dart:async'; // Future.delayed를 사용하기 위해 필요

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 1)); // 1초 동안 스플래시 화면 표시
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('hello'),
        ),
      ),
    );
  }
}
