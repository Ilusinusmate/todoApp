import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/common/data/notifiers/theme_notifier.dart';

class ThemePreferences {
  static late final SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('theme_mode') ?? false;
    themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setThemeMode(ThemeMode themeMode) async {
    await prefs.setBool('theme_mode', themeMode == ThemeMode.dark);
    themeNotifier.value = themeMode;
  }

  static ThemeMode getThemeMode() {
    final isDarkMode = prefs.getBool('theme_mode') ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
