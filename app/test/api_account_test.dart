import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/api.dart';
import 'api_auth_test.dart';

void main() {
  group('api account', () {
    test('account info', () async {
      await setupAccount();
      final response = await API().accountInfo();
      expect(response.email.isNotEmpty, true);
      expect(response.id.isNotEmpty, true);
    });
  });
}
