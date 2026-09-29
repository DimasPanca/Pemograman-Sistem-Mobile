import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PaperlogApp());
}

class PaperlogApp extends StatelessWidget {
  const PaperlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'paperlog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginScreen(),
    );
  }
}
