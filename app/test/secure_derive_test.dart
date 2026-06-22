import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/secure/secure.dart';

void main() {
  group('derive', () {
    test('derive master password', () async {
      final output = await deriveMasterPassword(32 * 1024, 3, 1, [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        0xa,
        0xb,
        0xc,
        0xd,
        0xe,
        0xf,
      ], 'password');
      expect((await output.extractBytes()).length, 32);
      expect(await output.extractBytes(), [
        69,
        149,
        180,
        219,
        230,
        175,
        237,
        162,
        4,
        227,
        71,
        146,
        220,
        55,
        0,
        89,
        48,
        234,
        224,
        16,
        12,
        241,
        194,
        137,
        120,
        168,
        223,
        108,
        123,
        3,
        205,
        66,
      ]);
    });
  });
}
