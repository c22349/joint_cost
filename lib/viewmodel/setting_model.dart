import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class SettingModel with ChangeNotifier {
  // 初期値
  bool _startPageA = true;
  bool get startPageA => _startPageA;

  Future<void> getSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final startPageAValue = prefs.getBool("startPageA") ?? false;
    _startPageA = startPageAValue;
    notifyListeners();
  }

  Future<void> setStartPageA(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("startPageA", value);
    _startPageA = value;
    notifyListeners();
  }
}
