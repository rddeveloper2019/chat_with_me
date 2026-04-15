import 'package:chat_with_me/services/native_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PowerSaveIndicator extends StatefulWidget {
  const PowerSaveIndicator({super.key});

  @override
  State<PowerSaveIndicator> createState() => _PowerSaveIndicatorState();
}

class _PowerSaveIndicatorState extends State<PowerSaveIndicator> {
  final _nativeService = GetIt.I<NativeService>();
  bool? _isPowerSave;

  @override
  void initState() {
    super.initState();
    _checkPowerSave();
  }

  Future<void> _checkPowerSave() async {
    final isOn = await _nativeService.isPowerSaveMode();
    if (mounted) {
      setState(() => _isPowerSave = isOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPowerSave == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isPowerSave!
            ? Colors.amber.withAlpha(125)
            : Colors.green.withAlpha(125),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isPowerSave! ? Icons.battery_saver : Icons.battery_full,
            size: 16,
            color: _isPowerSave! ? Colors.amber : Colors.green,
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
