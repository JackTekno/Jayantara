import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/help_screen.dart';

void main() {
  runApp(JayantaraApp());
}

class JayantaraApp extends StatefulWidget {
  @override
  _JayantaraAppState createState() => _JayantaraAppState();
}

class _JayantaraAppState extends State<JayantaraApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jayantara Scanner',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':
            (_) => HomeScreen(
              onThemeChanged: (val) {
                setState(() {
                  _isDarkMode = val;
                });
              },
            ),
        '/result': (_) => ResultScreen(),
        '/help': (_) => HelpScreen(),
      },
    );
  }
}
