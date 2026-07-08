import 'dart:core';

import 'package:mayflypass/databox/databox.dart';

class OtpAuthResult {
  final String issuer;
  final String account;
  final String secret;
  final TotpAlgorithm algorithm;
  final int digits;
  final int period;

  OtpAuthResult({
    required this.issuer,
    required this.account,
    required this.secret,
    required this.algorithm,
    required this.digits,
    required this.period,
  });

  static OtpAuthResult? parse(String? uri) {
    if (uri == null) return null;

    Uri? parsedUri;
    try {
      parsedUri = Uri.parse(uri);
    } catch (_) {
      return null;
    }

    // Validate scheme and host
    if (parsedUri.scheme != 'otpauth' || parsedUri.host != 'totp') {
      return null;
    }

    // Parse path: can be <issuer>:<account> or just <account>
    // Path starts with / so we remove it
    final path = parsedUri.path.substring(1);
    String issuer = '';
    String account = '';

    final colonIndex = path.indexOf(':');
    if (colonIndex > 0 && colonIndex < path.length - 1) {
      issuer = path.substring(0, colonIndex);
      account = path.substring(colonIndex + 1);
    } else {
      account = path;
    }

    // Parse query parameters
    String secret = '';
    int digits = 6;
    int period = 30;
    TotpAlgorithm algorithm = TotpAlgorithm.SHA1;

    for (final entry in parsedUri.queryParameters.entries) {
      final key = entry.key;
      final value = entry.value;

      switch (key) {
        case 'secret':
          secret = value;
          break;
        case 'digits':
          digits = int.tryParse(value) ?? 6;
          break;
        case 'period':
          period = int.tryParse(value) ?? 30;
          break;
        case 'issuer':
          if (value.isNotEmpty) {
            issuer = value;
          }
          break;
        case 'algorithm':
          switch (value.toUpperCase()) {
            case '':
              algorithm = TotpAlgorithm.SHA1;
            case 'SHA1':
              algorithm = TotpAlgorithm.SHA1;
            case 'SHA256':
              algorithm = TotpAlgorithm.SHA256;
            case 'SHA512':
              algorithm = TotpAlgorithm.SHA512;
            default:
              return null;
          }
      }
    }

    // Validate required fields
    if (secret.isEmpty) {
      return null;
    }

    return OtpAuthResult(
      issuer: Uri.decodeComponent(issuer),
      account: Uri.decodeComponent(account),
      secret: secret,
      algorithm: algorithm,
      digits: digits,
      period: period,
    );
  }
}
