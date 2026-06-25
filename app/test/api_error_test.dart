import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mayflypass/api/errors.dart';

void main() {
  group('FieldError parsing from JSON', () {
    test('FieldErrorEmailInvalid can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "email",
          "code": "EMAIL_INVALID"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorEmailInvalid>());
      expect(error.field, 'email');
    });

    test('FieldErrorCredentialsInvalid can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "password",
          "code": "CREDENTIALS_INVALID"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorCredentialsInvalid>());
      expect(error.field, 'password');
    });

    test('FieldErrorChallengeInvalid can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "captcha",
          "code": "CHALLENGE_INVALID"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorChallengeInvalid>());
      expect(error.field, 'captcha');
    });

    test(
      'FieldErrorValueTooShort can be parsed from JSON string with min value',
      () {
        const jsonString = '''
        {
          "field": "username",
          "code": "VALUE_TOO_SHORT",
          "min": 5
        }
      ''';
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final error = FieldError.fromJson(jsonMap);

        expect(error, isA<FieldErrorValueTooShort>());
        expect(error.field, 'username');
        expect((error as FieldErrorValueTooShort).min, 5);
      },
    );

    test(
      'FieldErrorValueTooLong can be parsed from JSON string with max value',
      () {
        const jsonString = '''
        {
          "field": "description",
          "code": "VALUE_TOO_LONG",
          "max": 500
        }
      ''';
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final error = FieldError.fromJson(jsonMap);

        expect(error, isA<FieldErrorValueTooLong>());
        expect(error.field, 'description');
        expect((error as FieldErrorValueTooLong).max, 500);
      },
    );

    test('FieldErrorValueRequired can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "name",
          "code": "VALUE_REQUIRED"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorValueRequired>());
      expect(error.field, 'name');
    });

    test('FieldErrorValueMismatch can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "password_confirmation",
          "code": "VALUE_MISMATCH"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorValueMismatch>());
      expect(error.field, 'password_confirmation');
    });

    test('FieldErrorValueDuplicated can be parsed from JSON string', () {
      const jsonString = '''
        {
          "field": "email",
          "code": "VALUE_DUPLICATED"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = FieldError.fromJson(jsonMap);

      expect(error, isA<FieldErrorValueDuplicated>());
      expect(error.field, 'email');
    });

    test(
      'ApiErrorBadRequestWithFields can be parsed from JSON string with multiple errors',
      () {
        const jsonString = '''
        {
          "errors": [
            {
              "field": "email",
              "code": "EMAIL_INVALID"
            },
            {
              "field": "password",
              "code": "VALUE_TOO_SHORT",
              "min": 8
            },
            {
              "field": "name",
              "code": "VALUE_REQUIRED"
            }
          ]
        }
      ''';
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final error = ApiErrorBadRequestWithFields.fromJson(jsonMap);

        expect(error.errors, hasLength(3));
        expect(error.errors[0], isA<FieldErrorEmailInvalid>());
        expect(error.errors[0].field, 'email');
        expect(error.errors[1], isA<FieldErrorValueTooShort>());
        expect(error.errors[1].field, 'password');
        expect((error.errors[1] as FieldErrorValueTooShort).min, 8);
        expect(error.errors[2], isA<FieldErrorValueRequired>());
        expect(error.errors[2].field, 'name');
      },
    );

    test('ApiErrorBadRequestWithFields handles empty errors list', () {
      const jsonString = '''{"errors": []}''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      final error = ApiErrorBadRequestWithFields.fromJson(jsonMap);

      expect(error.errors, isEmpty);
    });

    test('FieldError.fromJson throws for unknown error code', () {
      const jsonString = '''
        {
          "field": "unknown",
          "code": "UNKNOWN_ERROR"
        }
      ''';
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      expect(
        () => FieldError.fromJson(jsonMap),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('ApiError parsing from JSON', () {
    test('ApiError server error', () {
      final error = ApiError.build(500, null);
      expect(error, isA<ApiErrorInternalServerError>());
    });

    test('ApiError bad request', () {
      final error = ApiError.build(400, null);
      expect(error, isA<ApiErrorBadRequest>());
    });

    test('ApiError bad request with fields', () {
      final error = ApiError.build(400, <String, dynamic>{'errors': []});
      expect(error, isA<ApiErrorBadRequestWithFields>());
      expect(0, (error as ApiErrorBadRequestWithFields).errors.length);
    });

    test('ApiError bad request with fields invalid error', () {
      final error = ApiError.build(400, <String, dynamic>{'errors': 1});
      expect(error, isA<ApiErrorBadRequest>());
      final error2 = ApiError.build(400, null);
      expect(error2, isA<ApiErrorBadRequest>());
    });

    test('ApiError bad payload', () {
      final error = ApiError.build(422, null);
      expect(error, isA<ApiErrorInvalidPayload>());
    });

    test('ApiError unauthorized', () {
      final error = ApiError.build(401, null);
      expect(error, isA<ApiErrorUnauthorized>());
    });

    test('ApiError no network', () {
      final error = ApiError.build(0, null);
      expect(error, isA<ApiErrorNoNetwork>());
    });
  });
}
