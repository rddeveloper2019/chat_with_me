import 'package:chat_with_me/services/native_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PowerSaveIndicator extends StatelessWidget {
  const PowerSaveIndicator({super.key});

  Future<bool> _fetchPowerSaveStatus() async {
    final nativeService = GetIt.I<NativeService>();
    final version = await nativeService.getPlatformVersion();
    debugPrint('📱 Platform version: $version');

    final isOn = await nativeService.isPowerSaveMode();
    print('(**) => isPowerSave: $isOn');
    return isOn;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _fetchPowerSaveStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          debugPrint('❌ PowerSaveIndicator error: ${snapshot.error}');
          return const SizedBox.shrink();
        }

        final isPowerSave = snapshot.data!;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPowerSave
                ? Colors.amber.withAlpha(125)
                : Colors.green.withAlpha(125),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPowerSave ? Icons.battery_saver : Icons.battery_full,
                size: 16,
                color: isPowerSave ? Colors.amber : Colors.green,
              ),
              const SizedBox(width: 6),
            ],
          ),
        );
      },
    );
  }
}
