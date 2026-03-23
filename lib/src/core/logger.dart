import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Lightweight logger that works in all build modes.
/// On web: uses `debugPrint` which maps to `console.log` and survives release builds.
/// On native: uses `dart:developer` log.
class Log {
  static void d(String tag, String message) {
    if (kIsWeb) {
      // debugPrint goes to console.log on web, even in release mode
      debugPrint('[$tag] $message');
    } else {
      developer.log(message, name: tag);
    }
  }

  static void e(String tag, String message, [Object? error]) {
    final msg = error != null ? '$message: $error' : message;
    if (kIsWeb) {
      debugPrint('ERROR [$tag] $msg');
    } else {
      developer.log(msg, name: tag, level: 1000);
    }
  }
}
