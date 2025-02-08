import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:orders_sw/external/services/secure_storage/secure_storage.dart';

final class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageImpl({required FlutterSecureStorage flutterSecureStorage})
      : _flutterSecureStorage = flutterSecureStorage;

  @override
  Future<void> delete(String key) async =>
      await _flutterSecureStorage.delete(key: key);

  @override
  Future<String?> read(String key) async =>
      await _flutterSecureStorage.read(key: key);

  @override
  Future<void> write(String key, String value) async =>
      await _flutterSecureStorage.write(
        key: key,
        value: value,
      );
}
