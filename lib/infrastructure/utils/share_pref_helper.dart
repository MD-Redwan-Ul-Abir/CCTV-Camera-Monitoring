/*
*
* @author Syed Bipul Rahman
* @Support: https://github.com/Syed-Bipul-Rahman
* All rights reserved
*
*/

import 'package:shared_preferences/shared_preferences.dart';

import 'log_helper.dart';

class PrefsHelper {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  // Generic getter for String values
  static Future<String> getString(
    String key, {
    String defaultValue = "",
  }) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY GET FROM SHARED PREFS");
    return preferences.getString(key) ?? defaultValue;
  }

  // Generic getter for bool values
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY GET FROM SHARED PREFS");
    return preferences.getBool(key) ?? defaultValue;
  }

  // Generic getter for int values
  static Future<int> getInt(String key, {int defaultValue = -1}) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY GET FROM SHARED PREFS");
    return preferences.getInt(key) ?? defaultValue;
  }

  // Generic getter for double values
  static Future<double?> getDouble(String key) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY GET FROM SHARED PREFS");
    return preferences.getDouble(key);
  }

  // Generic setter for String values
  static Future<bool> setString(String key, String value) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY SET TO SHARED PREFS");
    return preferences.setString(key, value);
  }

  // Generic setter for bool values
  static Future<bool> setBool(String key, bool value) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY SET TO SHARED PREFS");
    return preferences.setBool(key, value);
  }

  // Generic setter for int values
  static Future<bool> setInt(String key, int value) async {
    final preferences = await _getPreferences();
    LoggerHelper.info(" $key, SUCCESSFULLY SET TO SHARED PREFS");
    return preferences.setInt(key, value);
  }

  // Generic setter for double values
  static Future<bool> setDouble(String key, double value) async {
    final preferences = await _getPreferences();
    LoggerHelper.info("$key, SUCCESSFULLY SET TO SHARED PREFS");
    return preferences.setDouble(key, value);
  }

  static Future<bool> remove(String key) async {
    final preferences = await _getPreferences();
    LoggerHelper.warn("$key, SUCCESSFULLY REMOVED FROM SHARED PREFS");
    return preferences.remove(key);
  }
}
