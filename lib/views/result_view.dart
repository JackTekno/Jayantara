import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final String scanResult;

  const ResultView({super.key, required this.scanResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            scanResult,
            style: const TextStyle(color: Colors.greenAccent, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
