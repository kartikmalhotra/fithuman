import 'package:shared_preferences/shared_preferences.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/const/app_constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._internal();

  get json => null;

  static Future<LocalStorageService?> getInstance() async {
    _instance ??= LocalStorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  /// Logged In
  bool? get isUserLoggedIn =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.loggedIn) ?? false;
  set isUserLoggedIn(bool? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.loggedIn, value);

  bool? get takeAssessment =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.takeAssessment) ?? false;
  set isTakenAssessment(bool? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.takeAssessment, value);

  String? get lastAssessment =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.lastAssessment) ?? "";
  set lastAssessment(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.lastAssessment, value);

  dynamic _getDataFromDisk(String key) {
    if (_preferences != null) {
      var value = _preferences!.get(key);
      return value;
    }
  }

  void removeDataFromLocalStorage() async {
    Application.localStorageService!.isUserLoggedIn = false;
    Application.userDetails = null;
  }

  void _saveDataToDisk<T>(String key, T content) async {
    if (_preferences != null) {
      if (content is String) {
        await _preferences!.setString(key, content);
      } else if (content is bool) {
        await _preferences!.setBool(key, content);
      } else if (content is int) {
        await _preferences!.setInt(key, content);
      } else if (content is double) {
        await _preferences!.setDouble(key, content);
      } else if (content is List<String>) {
        await _preferences!.setStringList(key, content);
      } else {
        await _preferences!.setString(key, content.toString());
      }
    }
  }
}
