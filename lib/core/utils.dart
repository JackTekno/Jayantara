import 'dart:io';

class Utils {
  static bool isValidIP(String ip) {
    final regex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\$');
    return regex.hasMatch(ip);
  }

  static Future<bool> isNmapInstalled() async {
    try {
      ProcessResult result = await Process.run('nmap', ['-V']);
      return result.stdout.toString().contains("Nmap version");
    } catch (e) {
      return false;
    }
  }
}
