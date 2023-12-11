import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localization/localization.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/providers/locale_provider.dart';
import 'package:apple_todo/screens/todo/home_page.dart';
import 'package:apple_todo/utilities/constants.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  Locale selectedLocale = defaultLocale;

  @override
  void initState() {
    selectedLocale = context.read<LocaleProvider>().selectedLocale;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: DropdownButton(
            isExpanded: true,
            value: selectedLocale,
            style: TextStyle(
              fontSize: 16,
              color: context.watch<TodoProvider>().isDark ? Colors.white : Colors.black,
            ),
            dropdownColor: context.watch<TodoProvider>().isDark ? const Color(0xff1e1e1e) : Colors.white,
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
                child: Text('Indonesian'),
              ),
              DropdownMenuItem(
                value: Locale('it', 'IT'),
                child: Text('Italian'),
              ),
              DropdownMenuItem(
                value: Locale('es', 'ES'),
                child: Text('Spanish'),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await context.read<LocaleProvider>().setLocale(selectedLocale);

            // Restart app
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
