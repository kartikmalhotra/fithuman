import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:brainfit/const/app_constants.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static FlutterSecureStorage? _preferences;

  SecureStorageService._internal();

  static SecureStorageService? getInstance() {
    _instance ??= SecureStorageService._internal();
    _preferences ??= const FlutterSecureStorage();
    return _instance;
  }

  Future<String> get email async =>
      await _getDataFromSecureStorage(AppSecureStoragePreferencesKeys.email) ??
      "";
  set email(Future<String> value) =>
      _saveDataToSecureStorage(AppSecureStoragePreferencesKeys.email, value);

  Future<String> get password async =>
      await _getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.userPassword) ??
      "";
  set password(Future<String> value) => _saveDataToSecureStorage(
      AppSecureStoragePreferencesKeys.userPassword, value);

  Future<String> get authToken async =>
      await _getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.authToken) ??
      "";
  set authToken(Future<String> value) => _saveDataToSecureStorage(
      AppSecureStoragePreferencesKeys.authToken, value);

  Future<String> get refreshToken async =>
      await _getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.refreshToken) ??
      "";
  set refreshToken(Future<String> value) => _saveDataToSecureStorage(
      AppSecureStoragePreferencesKeys.refreshToken, value);

  Future<String> get fcmToken async =>
      await _getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.fcmToken) ??
      "";
  set fcmToken(Future<String> value) =>
      _saveDataToSecureStorage(AppSecureStoragePreferencesKeys.fcmToken, value);

  Future<String?> _getDataFromSecureStorage(String key) async {
    String? value = await _preferences!.read(key: key);
    return value;
  }

  // Future<Map<String, String>> _getAllDataFromSecureStorage() async {
  //   Map<String, String> allValues = await _preferences!.readAll();
  //   return allValues;
  // }

  Future<void> deleteDataFromSecureStorage(String key) async {
    await _preferences!.delete(key: key);
  }

  Future<void> deleteAllDataFromSecureStorage() async {
    await _preferences!.deleteAll();
  }

  Future<void> _saveDataToSecureStorage(
      String key, Future<String> value) async {
    await _preferences!.write(key: key, value: await value);
  }
}
