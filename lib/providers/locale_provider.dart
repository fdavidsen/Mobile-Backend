import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _selectedLocale = const Locale('en', 'US');

  Locale get selectedLocale => _selectedLocale;

  set selectedLocale(Locale locale) {
    _selectedLocale = locale;
    notifyListeners();
  }
}
