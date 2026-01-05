import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoredCredentials {
  StoredCredentials({
    required this.mobile,
    required this.password,
  });

  final String mobile;
  final String password;
}

abstract class CredentialsStorage {
  Future<void> saveCredentials(String mobile, String password);
  Future<StoredCredentials?> readCredentials();
  Future<void> clearCredentials();
}

class SecureCredentialsStorage implements CredentialsStorage {
  SecureCredentialsStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _mobileKey = 'remember_mobile';
  static const _passwordKey = 'remember_password';

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> saveCredentials(String mobile, String password) async {
    await _secureStorage.write(key: _mobileKey, value: mobile);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  @override
  Future<StoredCredentials?> readCredentials() async {
    final mobile = await _secureStorage.read(key: _mobileKey);
    final password = await _secureStorage.read(key: _passwordKey);
    if (mobile == null || password == null) {
      return null;
    }
    return StoredCredentials(mobile: mobile, password: password);
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _mobileKey);
    await _secureStorage.delete(key: _passwordKey);
  }
}

