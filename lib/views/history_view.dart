import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Scan")),
      body: const Center(child: Text("Daftar scan akan muncul di sini")),
    );
  }
}