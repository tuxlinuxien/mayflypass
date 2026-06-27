import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/databox/databox.dart';

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
      expect(totp.createdAtMs.toInt(), 0);
    });

    test('totp values', () async {
      final totp = Totp(
        issuer: 'mayflypass.com',
        account: 'yoann@mail.com',
        secret: '0123456789ABCDEF',
        algorithm: TotpAlgorithm.SHA256,
        digits: 8,
        period: 60,
        createdAtMs: Int64(DateTime.now().millisecondsSinceEpoch),
      );

      final newTotp = Totp.fromBuffer(totp.writeToBuffer());
      expect(totp.issuer, newTotp.issuer);
      expect(totp.account, newTotp.account);
      expect(totp.secret, newTotp.secret);
      expect(totp.algorithm, newTotp.algorithm);
      expect(totp.digits, newTotp.digits);
      expect(totp.period, newTotp.period);
      expect(totp.createdAtMs.toInt(), newTotp.createdAtMs.toInt());
    });
  });
}
