import 'package:material_ui/material_ui.dart';
import 'package:tagly/config/theme.dart';

class TestApp extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: lightTheme, darkTheme: darkTheme, home: child);
  }
}
