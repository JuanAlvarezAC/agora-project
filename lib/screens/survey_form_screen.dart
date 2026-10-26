import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'location_screen.dart';

enum FloorMaterial { tierra, cemento, laminado }

const _floorLabels = {
  FloorMaterial.tierra: 'Tierra',
  FloorMaterial.cemento: 'Cemento / firme',
  FloorMaterial.laminado: 'Piso laminado o similar',
};

class SurveyFormScreen extends StatefulWidget {
  const SurveyFormScreen({
    super.key,
    required this.title,
    this.currentQuestion = 3,
    this.totalQuestions = 12,
  });

  final String title;
  final int currentQuestion;
  final int totalQuestions;

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _peopleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  FloorMaterial? _floor = FloorMaterial.cemento;

  @override
  void dispose() {
    _peopleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: guardar respuestas como draft y avanzar a la siguiente pregunta.
    // Por ahora salta directo a la captura de ubicación (último paso).
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final progress = widget.currentQuestion / widget.totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                const SizedBox(height: 22),
                Text(widget.title,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Pregunta ${widget.currentQuestion} de ${widget.totalQuestions}',
                  style: textTheme.bodySmall
                      ?.copyWith(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 14),

                // Pregunta numérica
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _question(context, '¿Cuántas personas viven en el hogar?'),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _peopleCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _decoration('Ej. 5'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Campo obligatorio'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Opción única
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _question(context, 'Material predominante del piso'),
                      const SizedBox(height: 8),
                      RadioGroup<FloorMaterial>(
                        groupValue: _floor,
                        onChanged: (v) => setState(() => _floor = v),
                        child: Column(
                          children: [
                            for (final option in FloorMaterial.values)
                              InkWell(
                                onTap: () => setState(() => _floor = option),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Radio<FloorMaterial>(
                                        value: option,
                                        activeColor: AppColors.orange,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(_floorLabels[option]!,
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: AppColors.brown,
                                            fontSize: 15,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Texto libre
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _question(context, 'Observaciones adicionales'),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _notesCtrl,
                        minLines: 3,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration('', radius: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saveAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Guardar y continuar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _question(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.brown,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
      );

  InputDecoration _decoration(String hint, {double radius = 26}) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.orange),
      errorBorder: border(Colors.red.shade400),
      focusedErrorBorder: border(Colors.red.shade400),
    );
  }
}