import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  //Singleton
  SharedPreferencesHelper._internal();
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  static SharedPreferencesHelper get instance =>
      SharedPreferencesHelper._instance;

  //helper
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  T? read<T>(String key) {
    Object? toGet = _prefs.get(key);

    return toGet == null ? null : jsonDecode(toGet.toString());
  }

  Future<bool> save(String key, value) async {
    var item = json.encode(value);
    return await _prefs.setString(key, item);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  bool check(String key) {
    return _prefs.containsKey(key);
  }
}
