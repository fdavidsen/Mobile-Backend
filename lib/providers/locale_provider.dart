import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en', 'US');

  Locale get locale => _locale;

  void set(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
