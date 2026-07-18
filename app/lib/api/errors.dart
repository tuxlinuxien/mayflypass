import 'package:freezed_annotation/freezed_annotation.dart';

part 'errors.g.dart';

sealed class FieldError {
  final String field;
  const FieldError({required this.field});

  factory FieldError.fromJson(Map<String, dynamic> json) {
    switch (json['code']! as String) {
      case 'USERNAME_INVALID':
        return FieldErrorUsernameInvalid.fromJson(json);
      case 'CREDENTIALS_INVALID':
        return FieldErrorCredentialsInvalid.fromJson(json);
      case 'CHALLENGE_INVALID':
        return FieldErrorChallengeInvalid.fromJson(json);
      case 'VALUE_TOO_SHORT':
        return FieldErrorValueTooShort.fromJson(json);
      case 'VALUE_TOO_LONG':
        return FieldErrorValueTooLong.fromJson(json);
      case 'VALUE_REQUIRED':
        return FieldErrorValueRequired.fromJson(json);
      case 'VALUE_MISMATCH':
        return FieldErrorValueMismatch.fromJson(json);
      case 'VALUE_DUPLICATED':
        return FieldErrorValueDuplicated.fromJson(json);
      default:
        throw FormatException('missing error handling $json');
    }
  }

  @override
  String toString() {
    return 'FieldError { field:$field }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorUsernameInvalid extends FieldError {
  final String code = 'USERNAME_INVALID';

  const FieldErrorUsernameInvalid({required super.field});

  factory FieldErrorUsernameInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorUsernameInvalidFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorCredentialsInvalid extends FieldError {
  final String code = 'CREDENTIALS_INVALID';

  const FieldErrorCredentialsInvalid({required super.field});

  factory FieldErrorCredentialsInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorCredentialsInvalidFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorChallengeInvalid extends FieldError {
  final String code = 'CHALLENGE_INVALID';

  const FieldErrorChallengeInvalid({required super.field});

  factory FieldErrorChallengeInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorChallengeInvalidFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorValueTooShort extends FieldError {
  final String code = 'VALUE_TOO_SHORT';
  final int min;

  const FieldErrorValueTooShort({required super.field, required this.min});

  factory FieldErrorValueTooShort.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueTooShortFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code, min:$min }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorValueTooLong extends FieldError {
  final String code = 'VALUE_TOO_LONG';
  final int max;

  const FieldErrorValueTooLong({required super.field, required this.max});

  factory FieldErrorValueTooLong.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueTooLongFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code, max:$max }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorValueRequired extends FieldError {
  final String code = 'VALUE_REQUIRED';

  const FieldErrorValueRequired({required super.field});

  factory FieldErrorValueRequired.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueRequiredFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorValueMismatch extends FieldError {
  final String code = 'VALUE_MISMATCH';

  const FieldErrorValueMismatch({required super.field});

  factory FieldErrorValueMismatch.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueMismatchFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorValueDuplicated extends FieldError {
  final String code = 'VALUE_DUPLICATED';

  const FieldErrorValueDuplicated({required super.field});

  factory FieldErrorValueDuplicated.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueDuplicatedFromJson(json);

  @override
  String toString() {
    return 'FieldError { field:$field, code:$code }';
  }
}

sealed class ApiError {
  const ApiError();

  factory ApiError.build(int code, Map<String, dynamic>? json) {
    try {
      switch (code) {
        case 0:
          return ApiErrorNoNetwork();
        case 400:
          if ((json?['errors'] is List<dynamic>)) {
            return ApiErrorBadRequestWithFields.fromJson(json!);
          } else {
            return ApiErrorBadRequest();
          }
        case 401:
          return ApiErrorUnauthorized();
        case 402:
          return ApiErrorPaymentRequired();
        case 403:
          return ApiErrorForbidden();
        case 404:
          return ApiErrorNotFound();
        case 405:
          return ApiErrorMethodNotAllowed();
        case 406:
          return ApiErrorNotAcceptable();
        case 407:
          return ApiErrorProxyAuthRequired();
        case 408:
          return ApiErrorRequestTimeout();
        case 409:
          return ApiErrorConflict();
        case 410:
          return ApiErrorGone();
        case 411:
          return ApiErrorLengthRequired();
        case 412:
          return ApiErrorPreconditionFailed();
        case 413:
          return ApiErrorContentTooLarge();
        case 414:
          return ApiErrorUriTooLong();
        case 415:
          return ApiErrorUnsupportedMediaType();
        case 416:
          return ApiErrorRangeNotSatisfiable();
        case 417:
          return ApiErrorExpectationFailed();
        case 418:
          return ApiErrorImATeapot();
        case 421:
          return ApiErrorMisdirectedRequest();
        case 422:
          return ApiErrorInvalidPayload();
        case 423:
          return ApiErrorLocked();
        case 424:
          return ApiErrorFailedDependency();
        case 425:
          return ApiErrorTooEarly();
        case 426:
          return ApiErrorUpgradeRequired();
        case 428:
          return ApiErrorPreconditionRequired();
        case 429:
          return ApiErrorTooManyRequests();
        case 431:
          return ApiErrorRequestHeaderFieldsTooLarge();
        case 451:
          return ApiErrorUnavailableForLegalReasons();
        default:
          return ApiErrorInternalServerError();
      }
    } catch (_) {
      return ApiErrorUnknown();
    }
  }
}

class ApiErrorNoNetwork extends ApiError {
  const ApiErrorNoNetwork();

  @override
  String toString() {
    return 'ApiErrorNoNetwork{}';
  }
}

class ApiErrorBadRequest extends ApiError {
  const ApiErrorBadRequest();

  @override
  String toString() {
    return 'ApiErrorBadRequest{}';
  }
}

class ApiErrorNotFound extends ApiError {
  const ApiErrorNotFound();

  @override
  String toString() {
    return 'ApiErrorNotFound{}';
  }
}

class ApiErrorMethodNotAllowed extends ApiError {
  const ApiErrorMethodNotAllowed();

  @override
  String toString() {
    return 'ApiErrorMethodNotAllowed{}';
  }
}

class ApiErrorInvalidPayload extends ApiError {
  const ApiErrorInvalidPayload();

  @override
  String toString() {
    return 'ApiErrorInvalidPayload{}';
  }
}

class ApiErrorUnsupportedMediaType extends ApiError {
  const ApiErrorUnsupportedMediaType();

  @override
  String toString() {
    return 'ApiErrorUnsupportedMediaType{}';
  }
}

class ApiErrorInternalServerError extends ApiError {
  const ApiErrorInternalServerError();

  @override
  String toString() {
    return 'ApiErrorInternalServerError{}';
  }
}

class ApiErrorUnauthorized extends ApiError {
  const ApiErrorUnauthorized();

  @override
  String toString() {
    return 'ApiErrorUnauthorized{}';
  }
}

class ApiErrorUnknown extends ApiError {
  const ApiErrorUnknown();

  @override
  String toString() {
    return 'ApiErrorUnknown{}';
  }
}

@JsonSerializable(createToJson: false)
class ApiErrorBadRequestWithFields extends ApiError {
  final List<FieldError> errors;

  const ApiErrorBadRequestWithFields({required this.errors});

  factory ApiErrorBadRequestWithFields.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorBadRequestWithFieldsFromJson(json);

  @override
  String toString() {
    return 'ApiErrorBadRequestWithFields{ $errors }';
  }
}

class ApiErrorPaymentRequired extends ApiError {
  const ApiErrorPaymentRequired();

  @override
  String toString() {
    return 'ApiErrorPaymentRequired{}';
  }
}

class ApiErrorForbidden extends ApiError {
  const ApiErrorForbidden();

  @override
  String toString() {
    return 'ApiErrorForbidden{}';
  }
}

class ApiErrorNotAcceptable extends ApiError {
  const ApiErrorNotAcceptable();

  @override
  String toString() {
    return 'ApiErrorNotAcceptable{}';
  }
}

class ApiErrorProxyAuthRequired extends ApiError {
  const ApiErrorProxyAuthRequired();

  @override
  String toString() {
    return 'ApiErrorProxyAuthRequired{}';
  }
}

class ApiErrorRequestTimeout extends ApiError {
  const ApiErrorRequestTimeout();

  @override
  String toString() {
    return 'ApiErrorRequestTimeout{}';
  }
}

class ApiErrorConflict extends ApiError {
  const ApiErrorConflict();

  @override
  String toString() {
    return 'ApiErrorConflict{}';
  }
}

class ApiErrorGone extends ApiError {
  const ApiErrorGone();

  @override
  String toString() {
    return 'ApiErrorGone{}';
  }
}

class ApiErrorLengthRequired extends ApiError {
  const ApiErrorLengthRequired();

  @override
  String toString() {
    return 'ApiErrorLengthRequired{}';
  }
}

class ApiErrorPreconditionFailed extends ApiError {
  const ApiErrorPreconditionFailed();

  @override
  String toString() {
    return 'ApiErrorPreconditionFailed{}';
  }
}

class ApiErrorContentTooLarge extends ApiError {
  const ApiErrorContentTooLarge();

  @override
  String toString() {
    return 'ApiErrorContentTooLarge{}';
  }
}

class ApiErrorUriTooLong extends ApiError {
  const ApiErrorUriTooLong();

  @override
  String toString() {
    return 'ApiErrorUriTooLong{}';
  }
}

class ApiErrorRangeNotSatisfiable extends ApiError {
  const ApiErrorRangeNotSatisfiable();

  @override
  String toString() {
    return 'ApiErrorRangeNotSatisfiable{}';
  }
}

class ApiErrorExpectationFailed extends ApiError {
  const ApiErrorExpectationFailed();

  @override
  String toString() {
    return 'ApiErrorExpectationFailed{}';
  }
}

class ApiErrorImATeapot extends ApiError {
  const ApiErrorImATeapot();

  @override
  String toString() {
    return 'ApiErrorImATeapot{}';
  }
}

class ApiErrorMisdirectedRequest extends ApiError {
  const ApiErrorMisdirectedRequest();

  @override
  String toString() {
    return 'ApiErrorMisdirectedRequest{}';
  }
}

class ApiErrorLocked extends ApiError {
  const ApiErrorLocked();

  @override
  String toString() {
    return 'ApiErrorLocked{}';
  }
}

class ApiErrorFailedDependency extends ApiError {
  const ApiErrorFailedDependency();

  @override
  String toString() {
    return 'ApiErrorFailedDependency{}';
  }
}

class ApiErrorTooEarly extends ApiError {
  const ApiErrorTooEarly();

  @override
  String toString() {
    return 'ApiErrorTooEarly{}';
  }
}

class ApiErrorUpgradeRequired extends ApiError {
  const ApiErrorUpgradeRequired();

  @override
  String toString() {
    return 'ApiErrorUpgradeRequired{}';
  }
}

class ApiErrorPreconditionRequired extends ApiError {
  const ApiErrorPreconditionRequired();

  @override
  String toString() {
    return 'ApiErrorPreconditionRequired{}';
  }
}

class ApiErrorTooManyRequests extends ApiError {
  const ApiErrorTooManyRequests();

  @override
  String toString() {
    return 'ApiErrorTooManyRequests{}';
  }
}

class ApiErrorRequestHeaderFieldsTooLarge extends ApiError {
  const ApiErrorRequestHeaderFieldsTooLarge();

  @override
  String toString() {
    return 'ApiErrorRequestHeaderFieldsTooLarge{}';
  }
}

class ApiErrorUnavailableForLegalReasons extends ApiError {
  const ApiErrorUnavailableForLegalReasons();

  @override
  String toString() {
    return 'ApiErrorUnavailableForLegalReasons{}';
  }
}
