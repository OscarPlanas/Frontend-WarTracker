import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedThemeMode = prefs.getInt('theme_mode');
    return savedThemeMode != null
        ? ThemeMode.values[savedThemeMode]
        : ThemeMode.system;
  }
}
