import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class StorageService {
  static Future<void> saveScanResult(ScanResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('scan_history') ?? [];
    history.add(jsonEncode({
      'target': result.target,
      'output': result.output,
      'timestamp': result.timestamp.toIso8601String(),
    }));
    await prefs.setStringList('scan_history', history);
  }
}
