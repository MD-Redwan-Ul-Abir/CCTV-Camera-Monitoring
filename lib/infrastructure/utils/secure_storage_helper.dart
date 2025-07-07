import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'log_helper.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Generic getter for String values
  static Future<String> getString(
      String key, {
        String defaultValue = "",
      }) async {
    try {
      final value = await _secureStorage.read(key: key);
      LoggerHelper.info("$key, SUCCESSFULLY GET FROM SECURE STORAGE");
      return value ?? defaultValue;
    } catch (e) {
      LoggerHelper.error("Failed to get $key from secure storage: $e");
      return defaultValue;
    }
  }

  // Generic getter for bool values
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    try {
      final value = await _secureStorage.read(key: key);
      LoggerHelper.info("$key, SUCCESSFULLY GET FROM SECURE STORAGE");
      if (value == null) return defaultValue;
      return value.toLowerCase() == 'true';
    } catch (e) {
      LoggerHelper.error("Failed to get $key from secure storage: $e");
      return defaultValue;
    }
  }

  // Generic getter for int values
  static Future<int> getInt(String key, {int defaultValue = -1}) async {
    try {
      final value = await _secureStorage.read(key: key);
      LoggerHelper.info("$key, SUCCESSFULLY GET FROM SECURE STORAGE");
      if (value == null) return defaultValue;
      return int.tryParse(value) ?? defaultValue;
    } catch (e) {
      LoggerHelper.error("Failed to get $key from secure storage: $e");
      return defaultValue;
    }
  }

  // Generic getter for double values
  static Future<double?> getDouble(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      LoggerHelper.info("$key, SUCCESSFULLY GET FROM SECURE STORAGE");
      if (value == null) return null;
      return double.tryParse(value);
    } catch (e) {
      LoggerHelper.error("Failed to get $key from secure storage: $e");
      return null;
    }
  }

  // Generic setter for String values
  static Future<bool> setString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      LoggerHelper.info("$key, SUCCESSFULLY SET TO SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to set $key to secure storage: $e");
      return false;
    }
  }

  // Generic setter for bool values
  static Future<bool> setBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      LoggerHelper.info("$key, SUCCESSFULLY SET TO SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to set $key to secure storage: $e");
      return false;
    }
  }

  // Generic setter for int values
  static Future<bool> setInt(String key, int value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      LoggerHelper.info("$key, SUCCESSFULLY SET TO SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to set $key to secure storage: $e");
      return false;
    }
  }

  // Generic setter for double values
  static Future<bool> setDouble(String key, double value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
      LoggerHelper.info("$key, SUCCESSFULLY SET TO SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to set $key to secure storage: $e");
      return false;
    }
  }

  // Remove a key from secure storage
  static Future<bool> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
      LoggerHelper.warn("$key, SUCCESSFULLY REMOVED FROM SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to remove $key from secure storage: $e");
      return false;
    }
  }

  // Clear all data from secure storage
  static Future<bool> clear() async {
    try {
      await _secureStorage.deleteAll();
      LoggerHelper.warn("ALL DATA SUCCESSFULLY CLEARED FROM SECURE STORAGE");
      return true;
    } catch (e) {
      LoggerHelper.error("Failed to clear secure storage: $e");
      return false;
    }
  }

  // Check if a key exists in secure storage
  static Future<bool> containsKey(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      LoggerHelper.error("Failed to check if $key exists in secure storage: $e");
      return false;
    }
  }

  // Get all keys from secure storage
  static Future<Set<String>> getAllKeys() async {
    try {
      final all = await _secureStorage.readAll();
      return all.keys.toSet();
    } catch (e) {
      LoggerHelper.error("Failed to get all keys from secure storage: $e");
      return <String>{};
    }
  }
}