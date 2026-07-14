// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnlockFormState {

 String get email; bool get withBiometricUnlock; MasterPasswordValue get masterPassword; FormStatus get status;
/// Create a copy of UnlockFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockFormStateCopyWith<UnlockFormState> get copyWith => _$UnlockFormStateCopyWithImpl<UnlockFormState>(this as UnlockFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.withBiometricUnlock, withBiometricUnlock) || other.withBiometricUnlock == withBiometricUnlock)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,email,withBiometricUnlock,masterPassword,status);

@override
String toString() {
  return 'UnlockFormState(email: $email, withBiometricUnlock: $withBiometricUnlock, masterPassword: $masterPassword, status: $status)';
}


}

/// @nodoc
abstract mixin class $UnlockFormStateCopyWith<$Res>  {
  factory $UnlockFormStateCopyWith(UnlockFormState value, $Res Function(UnlockFormState) _then) = _$UnlockFormStateCopyWithImpl;
@useResult
$Res call({
 String email, bool withBiometricUnlock, MasterPasswordValue masterPassword, FormStatus status
});




}
/// @nodoc
class _$UnlockFormStateCopyWithImpl<$Res>
    implements $UnlockFormStateCopyWith<$Res> {
  _$UnlockFormStateCopyWithImpl(this._self, this._then);

  final UnlockFormState _self;
  final $Res Function(UnlockFormState) _then;

/// Create a copy of UnlockFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? withBiometricUnlock = null,Object? masterPassword = null,Object? status = null,}) {
  return _then(UnlockFormState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,withBiometricUnlock: null == withBiometricUnlock ? _self.withBiometricUnlock : withBiometricUnlock // ignore: cast_nullable_to_non_nullable
as bool,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockFormState].
extension UnlockFormStatePatterns on UnlockFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockFormState value)  $default,){
final _that = this;
switch (_that) {
case _UnlockFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockFormState value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  bool withBiometricUnlock,  MasterPasswordValue masterPassword,  FormStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockFormState() when $default != null:
return $default(_that.email,_that.withBiometricUnlock,_that.masterPassword,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  bool withBiometricUnlock,  MasterPasswordValue masterPassword,  FormStatus status)  $default,) {final _that = this;
switch (_that) {
case _UnlockFormState():
return $default(_that.email,_that.withBiometricUnlock,_that.masterPassword,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  bool withBiometricUnlock,  MasterPasswordValue masterPassword,  FormStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UnlockFormState() when $default != null:
return $default(_that.email,_that.withBiometricUnlock,_that.masterPassword,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _UnlockFormState implements UnlockFormState {
  const _UnlockFormState({this.email = '', this.withBiometricUnlock = false, this.masterPassword = const MasterPasswordValue.pure(), this.status = FormStatus.initial});
  

@override@JsonKey() final  String email;
@override@JsonKey() final  bool withBiometricUnlock;
@override@JsonKey() final  MasterPasswordValue masterPassword;
@override@JsonKey() final  FormStatus status;

/// Create a copy of UnlockFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockFormStateCopyWith<_UnlockFormState> get copyWith => __$UnlockFormStateCopyWithImpl<_UnlockFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockFormState&&(identical(other.email, email) || other.email == email)&&(identical(other.withBiometricUnlock, withBiometricUnlock) || other.withBiometricUnlock == withBiometricUnlock)&&(identical(other.masterPassword, masterPassword) || other.masterPassword == masterPassword)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,email,withBiometricUnlock,masterPassword,status);

@override
String toString() {
  return 'UnlockFormState(email: $email, withBiometricUnlock: $withBiometricUnlock, masterPassword: $masterPassword, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UnlockFormStateCopyWith<$Res> implements $UnlockFormStateCopyWith<$Res> {
  factory _$UnlockFormStateCopyWith(_UnlockFormState value, $Res Function(_UnlockFormState) _then) = __$UnlockFormStateCopyWithImpl;
@override @useResult
$Res call({
 String email, bool withBiometricUnlock, MasterPasswordValue masterPassword, FormStatus status
});




}
/// @nodoc
class __$UnlockFormStateCopyWithImpl<$Res>
    implements _$UnlockFormStateCopyWith<$Res> {
  __$UnlockFormStateCopyWithImpl(this._self, this._then);

  final _UnlockFormState _self;
  final $Res Function(_UnlockFormState) _then;

/// Create a copy of UnlockFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? withBiometricUnlock = null,Object? masterPassword = null,Object? status = null,}) {
  return _then(_UnlockFormState(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,withBiometricUnlock: null == withBiometricUnlock ? _self.withBiometricUnlock : withBiometricUnlock // ignore: cast_nullable_to_non_nullable
as bool,masterPassword: null == masterPassword ? _self.masterPassword : masterPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormStatus,
  ));
}


}

// dart format on
