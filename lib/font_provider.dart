import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  String _currentFont = 'Default';

  FontProvider() {
    _loadFont();
  }

  String get currentFont => _currentFont;

  void setFont(String font) async {
    if (_currentFont != font) {
      _currentFont = font;
      notifyListeners();
      _saveFont();
    }
  }

  Future<void> _loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _currentFont = prefs.getString('font') ?? 'Default';
    notifyListeners();
  }

  Future<void> _saveFont() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('font', _currentFont);
  }
}