import 'package:freezed_annotation/freezed_annotation.dart';

part 'errors.g.dart';

sealed class FieldError {
  final String field;
  const FieldError({required this.field});

  factory FieldError.fromJson(Map<String, dynamic> json) {
    switch (json['code']! as String) {
      case 'EMAIL_INVALID':
        return FieldErrorEmailInvalid.fromJson(json);
      case 'CREDENTIALS_INVALID':
        return FieldErrorCredentialsInvalid.fromJson(json);
      case 'CAPTCHAT_INVALID':
        return FieldErrorCaptchatInvalid.fromJson(json);
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
        throw UnimplementedError('missing error handling $json');
    }
  }
}

@JsonSerializable(createToJson: false)
class FieldErrorEmailInvalid extends FieldError {
  final String code = 'EMAIL_INVALID';

  const FieldErrorEmailInvalid({required super.field});

  factory FieldErrorEmailInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorEmailInvalidFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorCredentialsInvalid extends FieldError {
  final String code = 'CREDENTIALS_INVALID';

  const FieldErrorCredentialsInvalid({required super.field});

  factory FieldErrorCredentialsInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorCredentialsInvalidFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorCaptchatInvalid extends FieldError {
  final String code = 'CAPTCHAT_INVALID';

  const FieldErrorCaptchatInvalid({required super.field});

  factory FieldErrorCaptchatInvalid.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorCaptchatInvalidFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorValueTooShort extends FieldError {
  final String code = 'VALUE_TOO_SHORT';
  final int min;

  const FieldErrorValueTooShort({required super.field, required this.min});

  factory FieldErrorValueTooShort.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueTooShortFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorValueTooLong extends FieldError {
  final String code = 'VALUE_TOO_LONG';
  final int max;

  const FieldErrorValueTooLong({required super.field, required this.max});

  factory FieldErrorValueTooLong.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueTooLongFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorValueRequired extends FieldError {
  final String code = 'VALUE_REQUIRED';

  const FieldErrorValueRequired({required super.field});

  factory FieldErrorValueRequired.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueRequiredFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorValueMismatch extends FieldError {
  final String code = 'VALUE_MISMATCH';

  const FieldErrorValueMismatch({required super.field});

  factory FieldErrorValueMismatch.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueMismatchFromJson(json);
}

@JsonSerializable(createToJson: false)
class FieldErrorValueDuplicated extends FieldError {
  final String code = 'VALUE_DUPLICATED';

  const FieldErrorValueDuplicated({required super.field});

  factory FieldErrorValueDuplicated.fromJson(Map<String, dynamic> json) =>
      _$FieldErrorValueDuplicatedFromJson(json);
}

sealed class ApiError {
  const ApiError();

  factory ApiError.build(int code, Map<String, dynamic>? json) {
    switch (code) {
      case 400:
        if ((json?['errors'] as List<dynamic>?) != null) {
          return ApiErrorBadRequestWithFields.fromJson(json!);
        } else {
          return ApiErrorBadRequest();
        }
      case 422:
        return ApiErrorInvalidPayload();
      case 401:
        return ApiErrorUnauthorized();
      default:
        return ApiErrorInternalServerError();
    }
  }
}

class ApiErrorBadRequest extends ApiError {
  const ApiErrorBadRequest();
}

class ApiErrorInvalidPayload extends ApiError {
  const ApiErrorInvalidPayload();
}

class ApiErrorInternalServerError extends ApiError {
  const ApiErrorInternalServerError();
}

class ApiErrorUnauthorized extends ApiError {
  const ApiErrorUnauthorized();
}

@JsonSerializable(createToJson: false)
class ApiErrorBadRequestWithFields extends ApiError {
  final List<FieldError> errors;

  const ApiErrorBadRequestWithFields({required this.errors});

  factory ApiErrorBadRequestWithFields.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorBadRequestWithFieldsFromJson(json);
}
