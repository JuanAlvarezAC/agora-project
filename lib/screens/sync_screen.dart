import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

enum SyncState { pendingSync, uploading, serverAccepted, syncError }

extension on SyncState {
  String get code => switch (this) {
        SyncState.pendingSync => 'PENDING_SYNC',
        SyncState.uploading => 'UPLOADING',
        SyncState.serverAccepted => 'SERVER_ACCEPTED',
        SyncState.syncError => 'SYNC_ERROR',
      };

  String get detail => switch (this) {
        SyncState.pendingSync => 'En espera de conexión',
        SyncState.uploading => 'Subiendo...',
        SyncState.serverAccepted => 'Confirmada por el servidor',
        SyncState.syncError => 'Reintentará automáticamente',
      };
}

class SyncItem {
  const SyncItem(this.title, this.state);
  final String title;
  final SyncState state;
}

// Datos de ejemplo; reemplazar por la cola de sincronización real (SQLite).
const _items = [
  SyncItem('Hogar #014 — Familia Pérez', SyncState.pendingSync),
  SyncItem('Hogar #018 — Familia Gómez', SyncState.uploading),
  SyncItem('Hogar #011 — Familia Ruiz', SyncState.serverAccepted),
  SyncItem('Hogar #007 — Familia Cruz', SyncState.syncError),
];

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              Text('Sincronización',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 10),
              Text(
                'La sincronización ocurre automáticamente al recuperar '
                'conexión. No requiere ninguna acción tuya.',
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              for (final item in _items) _SyncTile(item: item),
              const SizedBox(height: 2),
              Text(
                'Los datos locales se eliminan únicamente después de que el '
                'servidor confirma la recepción (SERVER_ACCEPTED).',
                style: textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted, fontSize: 12.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncTile extends StatelessWidget {
  const _SyncTile({required this.item});
  final SyncItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.brown,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.5,
                      )),
                  const SizedBox(height: 4),
                  Text(item.state.detail,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      )),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _SyncChip(state: item.state),
          ],
        ),
      ),
    );
  }
}

class _SyncChip extends StatelessWidget {
  const _SyncChip({required this.state});
  final SyncState state;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    Border? border;

    switch (state) {
      case SyncState.pendingSync:
      case SyncState.uploading:
        bg = const Color(0xFFFFE3C2);
        fg = AppColors.brown;
      case SyncState.serverAccepted:
        bg = AppColors.brown;
        fg = Colors.white;
      case SyncState.syncError:
        bg = Colors.white;
        fg = AppColors.brown;
        border = Border.all(color: AppColors.orange, width: 1.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Text(
        state.code,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}