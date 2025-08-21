import 'dart:io';

class NetworkService {
  static Future<bool> hasNetwork() async {
    try {
      final r = await InternetAddress.lookup('example.com');
      return r.isNotEmpty && r.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
