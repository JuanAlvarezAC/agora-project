import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'sync_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // TODO: obtener con el paquete geolocator (Geolocator.getCurrentPosition).
  final double _lat = 21.1619;
  final double _lng = -86.8515;
  final double _accuracyMeters = 4;

  bool _saving = false;

  Future<void> _confirm() async {
    setState(() => _saving = true);
    // TODO: guardar la encuesta en SQLite cifrado (p. ej. sqflite_sqlcipher)
    // con estado PENDING_SYNC.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    // Limpia el formulario de la pila: "atrás" desde Sincronización vuelve
    // a "Mis encuestas" y no a una encuesta ya guardada.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SyncScreen()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueStyle = textTheme.bodyLarge?.copyWith(
      color: AppColors.brown,
      fontSize: 16,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(showBack: true),
              const SizedBox(height: 22),
              Text('Ubicación del hogar',
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 18),
              // Placeholder del mapa; reemplazar por GoogleMap / flutter_map.
              Container(
                height: 275,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2DAD4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('[mapa]',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textMuted)),
              ),
              const SizedBox(height: 18),
              AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitud: ${_lat.toStringAsFixed(4)}',
                        style: valueStyle),
                    const SizedBox(height: 10),
                    Text('Longitud: ${_lng.toStringAsFixed(4)}',
                        style: valueStyle),
                    const SizedBox(height: 10),
                    Text('Precisión GPS: ±${_accuracyMeters.round()} m',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _confirm,
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
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Confirmar ubicación y guardar localmente'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'La encuesta se guarda primero en este dispositivo '
                '(SQLite cifrado), con o sin conexión a internet.',
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