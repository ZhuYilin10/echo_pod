import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FreshRssCredential {
  const FreshRssCredential({
    required this.url,
    required this.user,
    required this.pass,
  });

  final String url;
  final String user;
  final String pass;
}

class SecureCredentialStore {
  SecureCredentialStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _freshRssUrlKey = 'freshrss_url';
  static const String _freshRssUserKey = 'freshrss_user';
  static const String _freshRssPassKey = 'freshrss_pass';

  final FlutterSecureStorage _storage;

  Future<void> saveFreshRssCredential(FreshRssCredential credential) async {
    await _storage.write(key: _freshRssUrlKey, value: credential.url);
    await _storage.write(key: _freshRssUserKey, value: credential.user);
    await _storage.write(key: _freshRssPassKey, value: credential.pass);
  }

  Future<FreshRssCredential?> readFreshRssCredential() async {
    final url = await _storage.read(key: _freshRssUrlKey);
    final user = await _storage.read(key: _freshRssUserKey);
    final pass = await _storage.read(key: _freshRssPassKey);

    if (url == null || user == null || pass == null) return null;
    return FreshRssCredential(url: url, user: user, pass: pass);
  }

  Future<void> clearFreshRssCredential() async {
    await _storage.delete(key: _freshRssUrlKey);
    await _storage.delete(key: _freshRssUserKey);
    await _storage.delete(key: _freshRssPassKey);
  }
}
