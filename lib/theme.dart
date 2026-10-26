import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const brown = Color(0xFF5C3A21);
  static const orange = Color(0xFFFF8200);
  static const background = Color(0xFFFBF7F3);
  static const border = Color(0xFFD9CFC6);
  static const textMuted = Color(0xFF8A7B70);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      primary: AppColors.orange,
      surface: AppColors.background,
    ),
  );
  return base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
}