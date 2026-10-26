import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme.dart';

void main() => runApp(const EncuestasApp());

class EncuestasApp extends StatelessWidget {
  const EncuestasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuestas Anáhuac',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const SplashScreen(),
    );
  }
}