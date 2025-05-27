import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> categorizedCommands = {
    'Stealth & Evasion': [
      {'command': 'nmap -sS target', 'description': 'SYN scan (stealth scan).'},
      {'command': 'nmap -Pn target', 'description': 'Lewati host discovery.'},
    ],
    'Service & OS Detection': [
      {'command': 'nmap -sV target', 'description': 'Deteksi versi layanan.'},
      {
        'command': 'nmap -A target',
        'description': 'Agresif: OS, versi, traceroute, script.',
      },
    ],
    'Port Scanning': [
      {
        'command': 'nmap -p- target',
        'description': 'Scan semua 65535 port TCP.',
      },
      {'command': 'nmap -sU target', 'description': 'Scan semua port UDP.'},
    ],
    'Performance': [
      {
        'command': 'nmap -T4 target',
        'description': 'Tingkat kecepatan scanning (T0–T5).',
      },
      {'command': 'nmap -v target', 'description': 'Verbose mode.'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Referensi Perintah Nmap')),
      body: ListView(
        padding: EdgeInsets.all(12),
        children:
            categorizedCommands.entries.map((entry) {
              return ExpansionTile(
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.folder),
                children:
                    entry.value.map((cmd) {
                      return ListTile(
                        leading: Icon(Icons.terminal),
                        title: Text(
                          cmd['command']!,
                          style: TextStyle(fontFamily: 'monospace'),
                        ),
                        subtitle: Text(cmd['description']!),
                        trailing: IconButton(
                          icon: Icon(Icons.copy),
                          tooltip: 'Salin perintah',
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: cmd['command']!),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Perintah disalin ke clipboard'),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
              );
            }).toList(),
      ),
    );
  }
}
