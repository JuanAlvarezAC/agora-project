import 'package:flutter/material.dart';

import '../theme.dart';
import 'surveys_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _campaignCtrl = TextEditingController();

  @override
  void dispose() {
    _userCtrl.dispose();
    _campaignCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: autenticar usuario + código de campaña antes de navegar.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SurveysScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo horizontal: assets/images/logo_anahuac_horizontal.png
              Center(
                child: Image.asset(
                  'assets/images/logo_anahuac_horizontal.png',
                  height: 72,
                  errorBuilder: (context, error, stackTrace) => Text(
                    'Anáhuac México',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Misiones · Levantamiento',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Acceso de encuestador (BYOD)',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(context, 'Usuario'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _userCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration('correo@anahuac.mx'),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return 'Ingresa tu usuario';
                          if (!value.contains('@')) return 'Correo no válido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      _label(context, 'Código de campaña'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _campaignCtrl,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: _inputDecoration('MIS-2026-XXX'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa el código de campaña'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Tu acceso estará vigente solo mientras dure la campaña asignada.',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
      );

  InputDecoration _inputDecoration(String hint) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.orange),
      errorBorder: border(Colors.red.shade400),
      focusedErrorBorder: border(Colors.red.shade400),
    );
  }
}