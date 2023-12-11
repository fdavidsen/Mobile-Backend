import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apple_todo/utilities/constants.dart';

class LocaleProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  Locale _selectedLocale = defaultLocale;

  Locale get selectedLocale => _selectedLocale;

  Future<void> setLocale(Locale locale) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferencesKeyLocale, locale.toString());

    _selectedLocale = locale;

    notifyListeners();
  }

  Future<void> getLocaleFromPreferences() async {
    prefs = await SharedPreferences.getInstance();
    String? localeString = prefs.getString(sharedPreferencesKeyLocale);

    if (localeString == null) {
      _selectedLocale = defaultLocale;
    } else {
      _selectedLocale = Locale.fromSubtags(
        languageCode: localeString.split('_')[0],
        countryCode: localeString.split('_')[1],
      );
    }
    notifyListeners();
  }
}
