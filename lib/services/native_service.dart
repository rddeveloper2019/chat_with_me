import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NativeService {
  static const _channel = MethodChannel('com.example.chat_with_me/native');

  Future<bool> isPowerSaveMode() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      try {
        final result = await _channel.invokeMethod<bool>('isPowerSaveMode');
        return result ?? false;
      } on PlatformException catch (e) {
        debugPrint('❌ Native call failed: ${e.message}');
        return false;
      }
    }
    return false;
  }

  Future<void> vibrateForMessage({int duration = 200}) async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      try {
        await _channel.invokeMethod('vibrate', {'duration': duration});
      } on PlatformException catch (e) {
        debugPrint('❌ Vibrate failed: ${e.message}');
      }
    }
  }

  Future<String> getPlatformVersion() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      try {
        final version = await _channel.invokeMethod<String>(
          'getPlatformVersion',
        );
        return version ?? 'Unknown';
      } on PlatformException catch (e) {
        debugPrint('❌ Get version failed: ${e.message}');
        return 'Unknown';
      }
    }
    return Platform.operatingSystemVersion;
  }
}
