import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const port = 8080;

  /// PC Wi‑Fi IP — run `ipconfig` and pick your LAN IPv4 (e.g. 192.168.x.x)
  static const lanHost = '192.168.100.117';

  /// true = Android emulator (10.0.2.2), false = physical phone (lanHost)
  static const androidEmulator = false;

  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:$port';
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://127.0.0.1:$port';
    }
    if (Platform.isAndroid) {
      final host = androidEmulator ? '10.0.2.2' : lanHost;
      return 'http://$host:$port';
    }
    if (Platform.isIOS) return 'http://$lanHost:$port';
    return 'http://localhost:$port';
  }
}
