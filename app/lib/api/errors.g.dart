// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldErrorUsernameInvalid _$FieldErrorUsernameInvalidFromJson(
  Map<String, dynamic> json,
) => FieldErrorUsernameInvalid(field: json['field'] as String);

FieldErrorCredentialsInvalid _$FieldErrorCredentialsInvalidFromJson(
  Map<String, dynamic> json,
) => FieldErrorCredentialsInvalid(field: json['field'] as String);

FieldErrorChallengeInvalid _$FieldErrorChallengeInvalidFromJson(
  Map<String, dynamic> json,
) => FieldErrorChallengeInvalid(field: json['field'] as String);

FieldErrorValueTooShort _$FieldErrorValueTooShortFromJson(
  Map<String, dynamic> json,
) => FieldErrorValueTooShort(
  field: json['field'] as String,
  min: (json['min'] as num).toInt(),
);

FieldErrorValueTooLong _$FieldErrorValueTooLongFromJson(
  Map<String, dynamic> json,
) => FieldErrorValueTooLong(
  field: json['field'] as String,
  max: (json['max'] as num).toInt(),
);

FieldErrorValueRequired _$FieldErrorValueRequiredFromJson(
  Map<String, dynamic> json,
) => FieldErrorValueRequired(field: json['field'] as String);

FieldErrorValueMismatch _$FieldErrorValueMismatchFromJson(
  Map<String, dynamic> json,
) => FieldErrorValueMismatch(field: json['field'] as String);

FieldErrorValueDuplicated _$FieldErrorValueDuplicatedFromJson(
  Map<String, dynamic> json,
) => FieldErrorValueDuplicated(field: json['field'] as String);

ApiErrorBadRequestWithFields _$ApiErrorBadRequestWithFieldsFromJson(
  Map<String, dynamic> json,
) => ApiErrorBadRequestWithFields(
  errors: (json['errors'] as List<dynamic>)
      .map((e) => FieldError.fromJson(e as Map<String, dynamic>))
      .toList(),
);
