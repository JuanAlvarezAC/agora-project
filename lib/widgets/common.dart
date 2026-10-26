import 'package:flutter/material.dart';

import '../theme.dart';

/// Logo alineado a la derecha + línea divisoria (parte superior de las pantallas internas).
class AppHeader extends StatelessWidget {
  const AppHeader({super.key, this.showBack = false});

  /// Muestra una flecha de regreso (usa maybePop, así respeta PopScope).
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (showBack)
              IconButton(
                tooltip: 'Regresar',
                icon: const Icon(Icons.arrow_back, color: AppColors.brown),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            const Spacer(),
            Image.asset(
              'assets/images/logo_anahuac_horizontal.png',
              height: 56,
              errorBuilder: (context, error, stackTrace) => Text(
                'Anáhuac México',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.brown,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1.5, color: AppColors.border),
      ],
    );
  }
}

/// Tarjeta blanca con borde redondeado.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}