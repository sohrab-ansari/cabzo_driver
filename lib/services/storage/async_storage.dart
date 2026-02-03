import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AsyncStorage {
  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('✅ AsyncStorage initialized');
    } catch (e) {
      debugPrint('❌ AsyncStorage initialization failed: $e');
    }
  }

  /// Set item
  static Future<bool> setItem(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      debugPrint('❌ Error setting item $key: $e');
      return false;
    }
  }

  /// Get item
  static Future<String?> getItem(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      debugPrint('❌ Error getting item $key: $e');
      return null;
    }
  }

  /// Remove item
  static Future<bool> removeItem(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      debugPrint('❌ Error removing item $key: $e');
      return false;
    }
  }

  /// Clear all
  static Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      debugPrint('❌ Error clearing AsyncStorage: $e');
      return false;
    }
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    try {
      return _prefs.getKeys();
    } catch (e) {
      debugPrint('❌ Error getting all keys: $e');
      return {};
    }
  }
}
