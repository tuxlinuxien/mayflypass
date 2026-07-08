import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/databox/databox.pb.dart';
import 'package:mayflypass/helpers/otpauth.dart';

void main() {
  group('otpauth', () {
    test('empty', () async {
      expect(OtpAuthResult.parse(null), null);
      expect(OtpAuthResult.parse(''), null);
    });

    test('valid 1', () async {
      final res = OtpAuthResult.parse(
        'otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example',
      );
      expect(res?.issuer, 'Example');
      expect(res?.account, 'alice@google.com');
      expect(res?.secret, 'JBSWY3DPEHPK3PXP');
      expect(res?.algorithm, TotpAlgorithm.SHA1);
      expect(res?.digits, 6);
      expect(res?.period, 30);
    });

    test('valid 2', () async {
      final res = OtpAuthResult.parse(
        'otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example&algorithm=SHA256',
      );
      expect(res?.issuer, 'Example');
      expect(res?.account, 'alice@google.com');
      expect(res?.secret, 'JBSWY3DPEHPK3PXP');
      expect(res?.algorithm, TotpAlgorithm.SHA256);
      expect(res?.digits, 6);
      expect(res?.period, 30);
    });

    test('valid 3', () async {
      final res = OtpAuthResult.parse(
        'otpauth://totp/alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=Example&algorithm=SHA256',
      );
      expect(res?.issuer, 'Example');
      expect(res?.account, 'alice@google.com');
      expect(res?.secret, 'JBSWY3DPEHPK3PXP');
      expect(res?.algorithm, TotpAlgorithm.SHA256);
      expect(res?.digits, 6);
      expect(res?.period, 30);
    });

    test('missing issuer from query string', () async {
      final res = OtpAuthResult.parse(
        'otpauth://totp/Example:alice@google.com?secret=JBSWY3DPEHPK3PXP&issuer=&algorithm=SHA256',
      );
      expect(res?.issuer, 'Example');
      expect(res?.account, 'alice@google.com');
      expect(res?.secret, 'JBSWY3DPEHPK3PXP');
      expect(res?.algorithm, TotpAlgorithm.SHA256);
      expect(res?.digits, 6);
      expect(res?.period, 30);
    });
  });
}
