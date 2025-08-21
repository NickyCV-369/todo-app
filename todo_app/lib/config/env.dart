import 'package:flutter/foundation.dart';
import 'dart:io';

class Env {
  static String apiBase() {
    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000';
      return 'http://localhost:3000';
    } catch (_) {
      return 'http://localhost:3000';
    }
  }

  static String wsBase() {
    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000';
      return 'http://localhost:3000';
    } catch (_) {
      return 'http://localhost:3000';
    }
  }
}
