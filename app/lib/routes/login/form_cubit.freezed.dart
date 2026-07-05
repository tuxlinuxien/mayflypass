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
mixin _$LoginFormState {

 EmailValue get email; MasterPasswordValue get masterPassword; FormStatus get status; EmailValueError? get emailError; ApiError? get apiError;
/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginFormStateCopyWith<LoginFormState> get copyWith => _$LoginFormStateCopyWithImpl<LoginFormState>(this as LoginFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.status, status) || other.status == status)&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.apiError, apiError) || other.apiError == apiError));
}


@override
int get hashCode => Object.hash(runtimeType,email,masterPassword,status,emailError,apiError);

@override
String toString() {
  return 'LoginFormState(email: $email, masterPassword: $masterPassword, status: $status, emailError: $emailError, apiError: $apiError)';
}


}

/// @nodoc
abstract mixin class $LoginFormStateCopyWith<$Res>  {
  factory $LoginFormStateCopyWith(LoginFormState value, $Res Function(LoginFormState) _then) = _$LoginFormStateCopyWithImpl;
@useResult
$Res call({
 EmailValue email, MasterPasswordValue masterPassword, FormStatus status, EmailValueError? emailError, ApiError? apiError
});




}
/// @nodoc
class _$LoginFormStateCopyWithImpl<$Res>
    implements $LoginFormStateCopyWith<$Res> {
  _$LoginFormStateCopyWithImpl(this._self, this._then);

  final LoginFormState _self;
  final $Res Function(LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? masterPassword = null,Object? status = null,Object? emailError = freezed,Object? apiError = freezed,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailValue,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as EmailValueError?,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginFormState].
extension LoginFormStatePatterns on LoginFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginFormState value)  $default,){
final _that = this;
switch (_that) {
case _LoginFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginFormState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EmailValue email,  MasterPasswordValue masterPassword,  FormStatus status,  EmailValueError? emailError,  ApiError? apiError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.email,_that.masterPassword,_that.status,_that.emailError,_that.apiError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EmailValue email,  MasterPasswordValue masterPassword,  FormStatus status,  EmailValueError? emailError,  ApiError? apiError)  $default,) {final _that = this;
switch (_that) {
case _LoginFormState():
return $default(_that.email,_that.masterPassword,_that.status,_that.emailError,_that.apiError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EmailValue email,  MasterPasswordValue masterPassword,  FormStatus status,  EmailValueError? emailError,  ApiError? apiError)?  $default,) {final _that = this;
switch (_that) {
case _LoginFormState() when $default != null:
return $default(_that.email,_that.masterPassword,_that.status,_that.emailError,_that.apiError);case _:
  return null;

}
}

}

/// @nodoc


class _LoginFormState implements LoginFormState {
  const _LoginFormState({this.email = const EmailValue.pure(), this.masterPassword = const MasterPasswordValue.pure(), this.status = FormStatus.initial, this.emailError, this.apiError});
  

@override@JsonKey() final  EmailValue email;
@override@JsonKey() final  MasterPasswordValue masterPassword;
@override@JsonKey() final  FormStatus status;
@override final  EmailValueError? emailError;
@override final  ApiError? apiError;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginFormStateCopyWith<_LoginFormState> get copyWith => __$LoginFormStateCopyWithImpl<_LoginFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.status, status) || other.status == status)&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.apiError, apiError) || other.apiError == apiError));
}


@override
int get hashCode => Object.hash(runtimeType,email,masterPassword,status,emailError,apiError);

@override
String toString() {
  return 'LoginFormState(email: $email, masterPassword: $masterPassword, status: $status, emailError: $emailError, apiError: $apiError)';
}


}

/// @nodoc
abstract mixin class _$LoginFormStateCopyWith<$Res> implements $LoginFormStateCopyWith<$Res> {
  factory _$LoginFormStateCopyWith(_LoginFormState value, $Res Function(_LoginFormState) _then) = __$LoginFormStateCopyWithImpl;
@override @useResult
$Res call({
 EmailValue email, MasterPasswordValue masterPassword, FormStatus status, EmailValueError? emailError, ApiError? apiError
});




}
/// @nodoc
class __$LoginFormStateCopyWithImpl<$Res>
    implements _$LoginFormStateCopyWith<$Res> {
  __$LoginFormStateCopyWithImpl(this._self, this._then);

  final _LoginFormState _self;
  final $Res Function(_LoginFormState) _then;

/// Create a copy of LoginFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? masterPassword = null,Object? status = null,Object? emailError = freezed,Object? apiError = freezed,}) {
  return _then(_LoginFormState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as EmailValue,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as EmailValueError?,apiError: freezed == apiError ? _self.apiError : apiError // ignore: cast_nullable_to_non_nullable
as ApiError?,
  ));
}


}

// dart format on
