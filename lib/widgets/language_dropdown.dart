import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:apple_todo/providers/locale_provider.dart';
import 'package:apple_todo/screens/todo/home_page.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  Locale selectedLocale = const Locale('en', 'US');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          isExpanded: true,
          value: selectedLocale,
          onChanged: (value) {
            setState(() {
              selectedLocale = value!;
            });
          },
          items: const [
            DropdownMenuItem(
              value: Locale('en', 'US'),
              child: Text('English (US)'),
            ),
            DropdownMenuItem(
              value: Locale('id', 'ID'),
              child: Text('Bahasa Indonesia'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            context.read<LocaleProvider>().selectedLocale = selectedLocale;

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          },
          child: Text('setting_button_change_language'.i18n()),
        )
      ],
    );
  }
}
