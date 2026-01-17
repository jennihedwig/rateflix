import 'package:flutter/material.dart';
import 'package:rateflix/auth/auth_view.dart';
import 'package:rateflix/tabs/tab_view.dart';
import 'theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rateflix',
      themeMode: currentTheme.currentTheme(),
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: const AuthView(),
    );
  }
}
