import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _selectedLocale = const Locale('en', '');

  void _changeLocale(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer Biosecurity App',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      locale: _selectedLocale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('pa', ''),
        Locale('ta', ''),
        Locale('as', ''),
        Locale('mr', ''),
        Locale('bn', ''),
        Locale('te', ''),
        Locale('kn', ''),
        Locale('ml', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginPage(onLocaleChange: _changeLocale),
    );
  }
}