import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/storage/storage.dart';

void main() {
  group('storage', () {
    test('new totp default', () async {
      final totp = Totp();
      expect(totp.issuer, '');
      expect(totp.account, '');
      expect(totp.secret, '');
      expect(totp.algorithm, TotpAlgorithm.SHA1);
      expect(totp.digits, 6);
      expect(totp.period, 30);
    });

    test('totp values', () async {
      final totp = Totp(
        issuer: 'mayflypass.com',
        account: 'yoann@mail.com',
        secret: '0123456789ABCDEF',
        algorithm: TotpAlgorithm.SHA256,
        digits: 8,
        period: 60,
      );

      final newTotp = Totp.fromBuffer(totp.writeToBuffer());
      expect(totp.issuer, newTotp.issuer);
      expect(totp.account, newTotp.account);
      expect(totp.secret, newTotp.secret);
      expect(totp.algorithm, newTotp.algorithm);
      expect(totp.digits, newTotp.digits);
      expect(totp.period, newTotp.period);
    });
  });
}
