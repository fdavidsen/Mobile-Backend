import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:apple_todo/screens/splash_screen.dart';
import 'package:apple_todo/providers/locale_provider.dart';
import 'package:apple_todo/providers/todo_provider.dart';
import 'package:apple_todo/providers/concert_provider.dart';
import 'package:apple_todo/utilities/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => TodoProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ConcertProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    return ChangeNotifierProvider(
        create: (context) {
          final localeProvider = LocaleProvider();
          localeProvider.getLocaleFromPreferences();
          return localeProvider;
        },
        child: Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) => MaterialApp(
                  title: 'ToDo App',
                  theme: ThemeData(primarySwatch: Colors.blue),
                  debugShowCheckedModeBanner: false,
                  home: const SplashScreen(),
                  locale: localeProvider.selectedLocale,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    LocalJsonLocalization.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('id', 'ID'),
                    Locale('it', 'IT'),
                  ],
                  localeResolutionCallback: (locale, supportedLocales) {
                    if (supportedLocales.contains(locale)) {
                      return locale;
                    }
                    return defaultLocale;
                  },
                )));
  }
}
