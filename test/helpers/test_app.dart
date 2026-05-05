import 'package:flutter/material.dart';
import 'package:tagly/config/theme.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: lightTheme, darkTheme: darkTheme, home: child);
  }
}
