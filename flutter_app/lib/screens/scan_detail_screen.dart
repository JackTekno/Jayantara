import 'package:flutter/material.dart';

class ScanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> scanDetail;

  ScanDetailScreen({required this.scanDetail});

  @override
  Widget build(BuildContext context) {
    final ports = scanDetail['ports'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Scan: ${scanDetail['host']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target: ${scanDetail['target']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('IP: ${scanDetail['ip']}', style: TextStyle(fontSize: 16)),
            Text('Status: ${scanDetail['status']}', style: TextStyle(fontSize: 16)),
            Text('Timestamp: ${scanDetail['timestamp']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Ports:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: ports.length,
                itemBuilder: (context, index) {
                  final port = ports[index];
                  return Card(
                    child: ListTile(
                      title: Text('Port ${port['port']}/${port['protocol']}'),
                      subtitle: Text('State: ${port['state']}\nService: ${port['service']}\nVersion: ${port['version']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
