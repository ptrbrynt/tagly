import 'package:flutter/material.dart';
import 'package:tagly/db/database.dart';

Future<void> main() async {
  await openTaglyDatabase();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}
