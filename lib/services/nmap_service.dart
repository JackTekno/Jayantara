import 'dart:io';
import '../models/scan_result.dart';

class NmapService {
  static Future<String> scanNetwork(String target, String scanType) async {
    List<String> args = [target];
    if (scanType == 'Quick') args.insert(0, '-T4');
    if (scanType == 'Aggressive') args.insert(0, '-A');
    if (scanType == 'Stealth') args.insert(0, '-sS');
    if (scanType == 'Vuln Scan') args.insert(0, '--script=vuln');

    ProcessResult result = await Process.run('nmap', args);
    return result.stdout.toString();
  }
}
