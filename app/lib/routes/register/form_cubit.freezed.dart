// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterFormState {

 Email get email; MasterPassword get masterPassword; ConfirmMasterPassword get confirmMasterPassword; FormStatus get status; ValueError? get apiError; FieldError? get apiEmailError;
/// Create a copy of RegisterFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterFormStateCopyWith<RegisterFormState> get copyWith => _$RegisterFormStateCopyWithImpl<RegisterFormState>(this as RegisterFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.confirmMasterPassword, confirmMasterPassword) || other.confirmMasterPassword == confirmMasterPassword)&&(identical(other.status, status) || other.status == status)&&(identical(other.apiError, apiError) || other.apiError == apiError)&&(identical(other.apiEmailError, apiEmailError) || other.apiEmailError == apiEmailError));
}


@override
int get hashCode => Object.hash(runtimeType,email,masterPassword,confirmMasterPassword,status,apiError,apiEmailError);

@override
String toString() {
  return 'RegisterFormState(email: $email, masterPassword: $masterPassword, confirmMasterPassword: $confirmMasterPassword, status: $status, apiError: $apiError, apiEmailError: $apiEmailError)';
}


}

/// @nodoc
abstract mixin class $RegisterFormStateCopyWith<$Res>  {
  factory $RegisterFormStateCopyWith(RegisterFormState value, $Res Function(RegisterFormState) _then) = _$RegisterFormStateCopyWithImpl;
@useResult
$Res call({
 Email email, MasterPassword masterPassword, ConfirmMasterPassword confirmMasterPassword, FormStatus status, ValueError? apiError, FieldError? apiEmailError
});




}
/// @nodoc
class _$RegisterFormStateCopyWithImpl<$Res>
    implements $RegisterFormStateCopyWith<$Res> {
  _$RegisterFormStateCopyWithImpl(this._self, this._then);

  final RegisterFormState _self;
  final $Res Function(RegisterFormState) _then;

/// Create a copy of RegisterFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? masterPassword = null,Object? confirmMasterPassword = null,Object? status = null,Object? apiError = freezed,Object? apiEmailError = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Email,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPassword,confirmMasterPassword: null == confirmMasterPassword ? _self.confirmMasterPassword : confirmMasterPassword // ignore: cast_nullable_to_non_nullable
as ConfirmMasterPassword,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as ValueError?,apiEmailError: freezed == apiEmailError ? _self.apiEmailError : apiEmailError // ignore: cast_nullable_to_non_nullable
as FieldError?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterFormState].
extension RegisterFormStatePatterns on RegisterFormState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterFormState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterFormState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterFormState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterFormState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterFormState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Email email,  MasterPassword masterPassword,  ConfirmMasterPassword confirmMasterPassword,  FormStatus status,  ValueError? apiError,  FieldError? apiEmailError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterFormState() when $default != null:
return $default(_that.email,_that.masterPassword,_that.confirmMasterPassword,_that.status,_that.apiError,_that.apiEmailError);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Email email,  MasterPassword masterPassword,  ConfirmMasterPassword confirmMasterPassword,  FormStatus status,  ValueError? apiError,  FieldError? apiEmailError)  $default,) {final _that = this;
switch (_that) {
case _RegisterFormState():
return $default(_that.email,_that.masterPassword,_that.confirmMasterPassword,_that.status,_that.apiError,_that.apiEmailError);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Email email,  MasterPassword masterPassword,  ConfirmMasterPassword confirmMasterPassword,  FormStatus status,  ValueError? apiError,  FieldError? apiEmailError)?  $default,) {final _that = this;
switch (_that) {
case _RegisterFormState() when $default != null:
return $default(_that.email,_that.masterPassword,_that.confirmMasterPassword,_that.status,_that.apiError,_that.apiEmailError);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterFormState implements RegisterFormState {
  const _RegisterFormState({this.email = const Email.pure(), this.masterPassword = const MasterPassword.pure(), this.confirmMasterPassword = const ConfirmMasterPassword.pure(''), this.status = FormStatus.initial, this.apiError, this.apiEmailError});
  

@override@JsonKey() final  Email email;
@override@JsonKey() final  MasterPassword masterPassword;
@override@JsonKey() final  ConfirmMasterPassword confirmMasterPassword;
@override@JsonKey() final  FormStatus status;
@override final  ValueError? apiError;
@override final  FieldError? apiEmailError;

/// Create a copy of RegisterFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterFormStateCopyWith<_RegisterFormState> get copyWith => __$RegisterFormStateCopyWithImpl<_RegisterFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.confirmMasterPassword, confirmMasterPassword) || other.confirmMasterPassword == confirmMasterPassword)&&(identical(other.status, status) || other.status == status)&&(identical(other.apiError, apiError) || other.apiError == apiError)&&(identical(other.apiEmailError, apiEmailError) || other.apiEmailError == apiEmailError));
}


@override
int get hashCode => Object.hash(runtimeType,email,masterPassword,confirmMasterPassword,status,apiError,apiEmailError);

@override
String toString() {
  return 'RegisterFormState(email: $email, masterPassword: $masterPassword, confirmMasterPassword: $confirmMasterPassword, status: $status, apiError: $apiError, apiEmailError: $apiEmailError)';
}


}

/// @nodoc
abstract mixin class _$RegisterFormStateCopyWith<$Res> implements $RegisterFormStateCopyWith<$Res> {
  factory _$RegisterFormStateCopyWith(_RegisterFormState value, $Res Function(_RegisterFormState) _then) = __$RegisterFormStateCopyWithImpl;
@override @useResult
$Res call({
 Email email, MasterPassword masterPassword, ConfirmMasterPassword confirmMasterPassword, FormStatus status, ValueError? apiError, FieldError? apiEmailError
});




}
/// @nodoc
class __$RegisterFormStateCopyWithImpl<$Res>
    implements _$RegisterFormStateCopyWith<$Res> {
  __$RegisterFormStateCopyWithImpl(this._self, this._then);

  final _RegisterFormState _self;
  final $Res Function(_RegisterFormState) _then;

/// Create a copy of RegisterFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? masterPassword = null,Object? confirmMasterPassword = null,Object? status = null,Object? apiError = freezed,Object? apiEmailError = freezed,}) {
  return _then(_RegisterFormState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Email,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPassword,confirmMasterPassword: null == confirmMasterPassword ? _self.confirmMasterPassword : confirmMasterPassword // ignore: cast_nullable_to_non_nullable
as ConfirmMasterPassword,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as ValueError?,apiEmailError: freezed == apiEmailError ? _self.apiEmailError : apiEmailError // ignore: cast_nullable_to_non_nullable
as FieldError?,
  ));
}


}

// dart format on
