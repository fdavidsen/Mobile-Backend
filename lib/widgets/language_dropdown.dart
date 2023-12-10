import 'package:apple_todo/main.dart';
import 'package:apple_todo/providers/locale_provider.dart';
import 'package:apple_todo/screens/todo/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({
    super.key,
    required this.getLanguage,
    required this.changeLanguage,
  });
  final Function getLanguage;
  final Function changeLanguage;

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  // Locale selectedValue = const Locale('en', 'US');
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: widget.getLanguage(),
      onChanged: (newValue) {
        widget.changeLanguage();
        setState(() {
          context.read<LocaleProvider>().set(newValue as Locale);
        });
        // setState(() {
        //   context.read<LocaleProvider>().set(newValue!);
        //   context.read<LocaleProvider>().set(newValue!);
        //   context.read<LocaleProvider>().set(newValue!);
        //   context.read<LocaleProvider>().set(newValue!);
        //   selectedValue = newValue!;
        // });
        // context.read<LocaleProvider>().set(newValue!);
        // HomePage.rerender();
      },
      items: const [
        DropdownMenuItem(
          value: Locale('id', 'ID'),
          child: Text('Indonesia'),
        ),
        DropdownMenuItem(
          value: Locale('en', 'US'),
          child: Text('English'),
        ),
      ],
    );
  }
}
