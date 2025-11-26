import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isDarkMode = false;
  String? loadedTheme;

  loadTheme() async {
    loadedTheme = await _storage.read(key: "theme");

    if (loadedTheme == 'true') {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    String themeValue = _isDarkMode.toString();
    await _storage.write(key: "theme", value: themeValue);
    notifyListeners();
  }

  //load Get Started Screen
  String? seenGetStarted;
  Future<void> checkGetStarted() async {
    loadTheme();
    final storage = const FlutterSecureStorage();
    final value = await storage.read(key: "get_started");
    if (value == null) {
      seenGetStarted = "false";
    } else {
      seenGetStarted = value;
    }
    notifyListeners();
  }
}
