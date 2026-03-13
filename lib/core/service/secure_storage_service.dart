import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  SecureStorageService._internal();
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveData(String key, String value) async{
    await _storage.write(key: key, value: value);
  }

  Future<String> getData(String key) async{
    return await _storage.read(key: key) ?? '';
  }

  Future<void> deleteData() async{
    await _storage.deleteAll();
  }
}