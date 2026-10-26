import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goToHome);
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo completo (escudo + "MÉXICO"). Colócalo en
                  // assets/images/logo_anahuac_mexico.png
                  Image.asset(
                    'assets/images/logo_anahuac_mexico.png',
                    width: 170,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 170,
                      height: 170,
                      child: Icon(Icons.school,
                          size: 80, color: AppColors.brown),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Encuestas Anáhuac',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Misiones · Levantamiento de información',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barra inferior bicolor
          SizedBox(
            height: 4,
            child: Row(
              children: const [
                Expanded(child: ColoredBox(color: AppColors.brown)),
                Expanded(child: ColoredBox(color: AppColors.orange)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}