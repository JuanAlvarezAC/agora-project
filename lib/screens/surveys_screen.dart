import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'survey_form_screen.dart';
import 'sync_screen.dart';

enum SurveyStatus { draft, completed }

class Survey {
  const Survey(this.title, this.detail, this.status);
  final String title;
  final String detail;
  final SurveyStatus status;
}

// Datos de ejemplo; reemplazar por los de tu backend / base local.
const _surveys = [
  Survey('Hogar #014 — Familia Pérez', 'En progreso · iniciada hoy',
      SurveyStatus.draft),
  Survey('Hogar #018 — Familia Gómez', 'En progreso · iniciada ayer',
      SurveyStatus.draft),
  Survey('Hogar #016 — Familia Ramírez', 'Concluida · 08 sep 2026',
      SurveyStatus.completed),
  Survey('Hogar #009 — Familia Torres', 'Concluida · 07 sep 2026',
      SurveyStatus.completed),
  Survey('Hogar #003 — Familia Díaz', 'Concluida · 05 sep 2026',
      SurveyStatus.completed),
];

class SurveysScreen extends StatelessWidget {
  const SurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final drafts =
        _surveys.where((s) => s.status == SurveyStatus.draft).toList();
    final done =
        _surveys.where((s) => s.status == SurveyStatus.completed).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Text('Mis encuestas',
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.brown,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  IconButton(
                    tooltip: 'Sincronización',
                    icon: const Icon(Icons.cloud_sync_outlined,
                        color: AppColors.brown),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SyncScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('Comunidad El Roble · Misiones Verano 2026',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 18),
              _sectionLabel(context, 'EN PROGRESO'),
              for (final s in drafts) _SurveyTile(survey: s),
              const SizedBox(height: 4),
              _sectionLabel(context, 'CONCLUIDAS'),
              for (final s in done) _SurveyTile(survey: s),
              const SizedBox(height: 4),
              Text(
                'Las encuestas concluidas son de solo lectura: no pueden '
                'reabrirse ni modificarse desde la app.',
                style: textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 0.4,
                )),
      );
}

class _SurveyTile extends StatelessWidget {
  const _SurveyTile({required this.survey});
  final Survey survey;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDraft = survey.status == SurveyStatus.draft;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        // Las concluidas son solo lectura: sin acción al tocar.
        onTap: isDraft
            ? () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SurveyFormScreen(title: survey.title),
                ))
            : null,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(survey.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 4),
                  Text(survey.detail,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      )),
                ],
              ),
            ),
            _StatusChip(isDraft: isDraft),
            if (isDraft) ...[
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right,
                  size: 20, color: AppColors.textMuted),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isDraft});
  final bool isDraft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isDraft ? const Color(0xFFFFE3C2) : const Color(0xFFE5DCD5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isDraft ? 'DRAFT' : 'COMPLETED',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDraft ? AppColors.brown : const Color(0xFF6B5B50),
        ),
      ),
    );
  }
}