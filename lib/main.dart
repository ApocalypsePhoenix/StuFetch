import 'package:flutter/material.dart';
import 'package:student_fetch/view/splashscreen.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stu-Fetch',
      theme: ThemeData(primarySwatch: Colors.blue ),
      home: const SplashScreen(),
        );
  }
}

//ISAC RUSSELL PAULBERT
//297454