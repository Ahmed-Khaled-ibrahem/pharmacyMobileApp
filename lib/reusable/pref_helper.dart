import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static late SharedPreferences pref;

  static init() async {
    pref = await SharedPreferences.getInstance();
  }

  static void putDataInSharedPreference({
    required dynamic value,
    required String key,
  }) {
    if (value is String) {
      pref.setString(key, value);
    } else if (value is int) {
      pref.setInt(key, value);
    } else if (value is bool) {
      pref.setBool(key, value);
    } else if (value is double) {
      pref.setDouble(key, value);
    } else if (value is Map) {
      pref.setString(key, json.encode(value));
    }
  }

  static dynamic getDataFromSharedPreference({
    required String key,
  }) {
    return pref.get(key);
  }

  static void clearDataFromSharedPreference({
    required String key,
  }) {
    pref.remove(key);
  }

  static void clearAllSharedPreference() {
    pref.clear();
  }
}
