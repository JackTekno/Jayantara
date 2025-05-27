import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'log_screen.dart'; // Import the LogScreen

class HomeScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;

  HomeScreen({this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _targetController = TextEditingController();
  String _selectedOption = '-sV';
  bool _isLoading = false;
  Map<String, dynamic>? _scanResult;
  bool _isDarkMode = false;

  final List<String> _nmapOptions = ['-sS', '-sV', '-Pn', '-O', '-sU', '-T4'];

  bool isValidInput(String input) {
    if (input.isEmpty) return false;
    final firstPart = input.trim().split(' ').first;

    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    final domainRegex = RegExp(r'^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$');

    return ipRegex.hasMatch(firstPart) || domainRegex.hasMatch(firstPart);
  }

  Map<String, String> parseScanInput(String input) {
    final parts = input.trim().split(' ');
    final target = parts[0];
    final options = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return {'target': target, 'options': options};
  }

  void _startScan() async {
    final input = _targetController.text.trim();
    if (!isValidInput(input)) {
      _showError('Masukkan alamat IP atau domain yang valid!');
      return;
    }

    final parsedInput = parseScanInput(input);
    final target = parsedInput['target']!;
    final options =
        parsedInput['options']!.isEmpty
            ? _selectedOption
            : parsedInput['options']!;

    setState(() {
      _isLoading = true;
      _scanResult = null;
    });

    final url = Uri.parse('http://178.128.223.176:8000/scan');
    final body = jsonEncode({'target': target, 'options': options});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _scanResult = data;
        });
        Navigator.pushNamed(context, '/result', arguments: data);
      } else {
        _showError('Gagal scan. Cek target atau backend!');
      }
    } catch (e) {
      _showError('Koneksi gagal: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jayantara Scanner'),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (val) {
              setState(() {
                _isDarkMode = val;
              });
              if (widget.onThemeChanged != null) {
                widget.onThemeChanged!(val);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => Navigator.pushNamed(context, '/help'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'Target (IP/domain) + opsi Nmap (optional)',
                border: OutlineInputBorder(),
                hintText: 'Contoh: 192.168.1.1 -sV atau unjaya.ac.id',
                prefixIcon: Icon(Icons.search), // icon input
              ),
              onSubmitted: (_) => _startScan(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedOption,
              decoration: InputDecoration(
                labelText: 'Opsi Nmap default',
                border: OutlineInputBorder(),
              ),
              items: _nmapOptions
                  .map(
                    (opt) => DropdownMenuItem(value: opt, child: Text(opt)),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedOption = val);
                }
              },
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.rocket_launch), // ganti ikon tombol scan
              label: Text(
                _isLoading ? 'Scanning...' : 'SCAN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _isLoading ? null : _startScan,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: _isLoading ? Colors.grey : Colors.blueAccent,
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogScreen()),
                );
              },
              child: Text('Lihat Riwayat Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
