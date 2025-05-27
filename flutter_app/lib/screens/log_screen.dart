import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'scan_detail_screen.dart'; // Import the ScanDetailScreen

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<dynamic> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final url = Uri.parse('http://178.128.223.176:8000/logs');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _logs = jsonDecode(response.body);
        });
      } else {
        _showError('Gagal mengambil riwayat scan.');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Scan')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _logs.isEmpty
              ? Center(child: Text('Tidak ada riwayat scan.'))
              : ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return Card(
                      child: ListTile(
                        title: Text('Target: ${log['target']}'),
                        subtitle: Text('Timestamp: ${log['timestamp']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScanDetailScreen(scanDetail: log),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
