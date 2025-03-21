import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'core/themes.dart';

void main() {
  runApp(const NmapScannerApp());
}

class NmapScannerApp extends StatelessWidget {
  const NmapScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jayantara Nmap Scanner',
      theme: cyberSecurityTheme,
      home: const HomeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
