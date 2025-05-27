class Validator {
  static bool isValidTarget(String input) {
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}'
      r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    final domainRegex = RegExp(
      r'^(?!-)[A-Za-z0-9-]{1,63}(?<!-)\.'
      r'[A-Za-z]{2,6}(\.[A-Za-z]{2,6})?$',
    );

    return ipRegex.hasMatch(input) || domainRegex.hasMatch(input);
  }
}
