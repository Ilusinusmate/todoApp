import 'package:flutter/material.dart';
import 'package:todoapp/common/data/data_source/shared_preferences.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
  ThemePreferences.getThemeMode(),
);
