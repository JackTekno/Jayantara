import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> scanResult =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final ports = scanResult['ports'] as List<dynamic>;

    Color getIconColor(String state) {
      switch (state) {
        case 'open':
          return Colors.green;
        case 'filtered':
          return Colors.orange;
        case 'closed':
        default:
          return Colors.red;
      }
    }

    IconData getIconData(String state) {
      switch (state) {
        case 'open':
          return Icons.check_circle;
        case 'filtered':
          return Icons.help_outline;
        case 'closed':
        default:
          return Icons.cancel;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Hasil Scan: ${scanResult['host']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            ports.isEmpty
                ? Center(child: Text('Tidak ada port terbuka.'))
                : ListView.builder(
                  itemCount: ports.length,
                  itemBuilder: (context, index) {
                    final port = ports[index];
                    final state = port['state'] ?? 'unknown';

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          getIconData(state),
                          color: getIconColor(state),
                        ),
                        title: Text('Port ${port['port']}/${port['protocol']}'),
                        subtitle: Text(
                          'State: $state\n'
                          'Service: ${port['service'] ?? '-'}\n'
                          'Version: ${port['version'] ?? '-'}',
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
