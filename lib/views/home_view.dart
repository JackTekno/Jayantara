import 'package:flutter/material.dart';
import '../services/nmap_service.dart';
import 'result_view.dart';
import 'history_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _ipController = TextEditingController();
  String _selectedScanType = 'Quick';
  bool _isScanning = false;

  void _startScan() async {
    if (_ipController.text.isEmpty) return;
    setState(() => _isScanning = true);
    String result = await NmapService.scanNetwork(_ipController.text, _selectedScanType);
    setState(() => _isScanning = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultView(scanResult: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jayantara Nmap Scanner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: "Masukkan IP Address",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.black54,
              ),
              style: const TextStyle(color: Colors.greenAccent),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedScanType,
              items: ['Quick', 'Aggressive', 'Stealth', 'Vuln Scan']
                  .map((scan) => DropdownMenuItem(value: scan, child: Text(scan)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedScanType = value!),
              dropdownColor: Colors.black54,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isScanning ? null : _startScan,
              child: _isScanning ? CircularProgressIndicator() : const Text("Mulai Scan"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryView()),
                );
              },
              child: const Text("Lihat History"),
            ),
          ],
        ),
      ),
    );
  }
}