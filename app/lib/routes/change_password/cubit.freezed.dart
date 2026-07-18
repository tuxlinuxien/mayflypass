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
mixin _$ChangePasswordState {

 ChangePasswordStatus get status; MasterPasswordValue get oldPassword; MasterPasswordValue get newPassword; ConfirmMasterPasswordValue get confirmNewPassword; MasterPasswordValueError? get oldPasswordError; MasterPasswordValueError? get newPasswordError;
/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordStateCopyWith<ChangePasswordState> get copyWith => _$ChangePasswordStateCopyWithImpl<ChangePasswordState>(this as ChangePasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.oldPassword, oldPassword) || other.oldPassword == oldPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.confirmNewPassword, confirmNewPassword) || other.confirmNewPassword == confirmNewPassword)&&(identical(other.oldPasswordError, oldPasswordError) || other.oldPasswordError == oldPasswordError)&&(identical(other.newPasswordError, newPasswordError) || other.newPasswordError == newPasswordError));
}


@override
int get hashCode => Object.hash(runtimeType,status,oldPassword,newPassword,confirmNewPassword,oldPasswordError,newPasswordError);

@override
String toString() {
  return 'ChangePasswordState(status: $status, oldPassword: $oldPassword, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword, oldPasswordError: $oldPasswordError, newPasswordError: $newPasswordError)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordStateCopyWith<$Res>  {
  factory $ChangePasswordStateCopyWith(ChangePasswordState value, $Res Function(ChangePasswordState) _then) = _$ChangePasswordStateCopyWithImpl;
@useResult
$Res call({
 ChangePasswordStatus status, MasterPasswordValue oldPassword, MasterPasswordValue newPassword, ConfirmMasterPasswordValue confirmNewPassword, MasterPasswordValueError? oldPasswordError, MasterPasswordValueError? newPasswordError
});




}
/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final ChangePasswordState _self;
  final $Res Function(ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? oldPassword = null,Object? newPassword = null,Object? confirmNewPassword = null,Object? oldPasswordError = freezed,Object? newPasswordError = freezed,}) {
  return _then(ChangePasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChangePasswordStatus,oldPassword: null == oldPassword ? _self.oldPassword : oldPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,confirmNewPassword: null == confirmNewPassword ? _self.confirmNewPassword : confirmNewPassword // ignore: cast_nullable_to_non_nullable
as ConfirmMasterPasswordValue,oldPasswordError: freezed == oldPasswordError ? _self.oldPasswordError : oldPasswordError // ignore: cast_nullable_to_non_nullable
as MasterPasswordValueError?,newPasswordError: freezed == newPasswordError ? _self.newPasswordError : newPasswordError // ignore: cast_nullable_to_non_nullable
as MasterPasswordValueError?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordState].
extension ChangePasswordStatePatterns on ChangePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangePasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangePasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangePasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChangePasswordStatus status,  MasterPasswordValue oldPassword,  MasterPasswordValue newPassword,  ConfirmMasterPasswordValue confirmNewPassword,  MasterPasswordValueError? oldPasswordError,  MasterPasswordValueError? newPasswordError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.status,_that.oldPassword,_that.newPassword,_that.confirmNewPassword,_that.oldPasswordError,_that.newPasswordError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChangePasswordStatus status,  MasterPasswordValue oldPassword,  MasterPasswordValue newPassword,  ConfirmMasterPasswordValue confirmNewPassword,  MasterPasswordValueError? oldPasswordError,  MasterPasswordValueError? newPasswordError)  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState():
return $default(_that.status,_that.oldPassword,_that.newPassword,_that.confirmNewPassword,_that.oldPasswordError,_that.newPasswordError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChangePasswordStatus status,  MasterPasswordValue oldPassword,  MasterPasswordValue newPassword,  ConfirmMasterPasswordValue confirmNewPassword,  MasterPasswordValueError? oldPasswordError,  MasterPasswordValueError? newPasswordError)?  $default,) {final _that = this;
switch (_that) {
case _ChangePasswordState() when $default != null:
return $default(_that.status,_that.oldPassword,_that.newPassword,_that.confirmNewPassword,_that.oldPasswordError,_that.newPasswordError);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePasswordState implements ChangePasswordState {
  const _ChangePasswordState({this.status = ChangePasswordStatus.ready, this.oldPassword = const MasterPasswordValue.pure(), this.newPassword = const MasterPasswordValue.pure(), this.confirmNewPassword = const ConfirmMasterPasswordValue.pure(''), this.oldPasswordError = null, this.newPasswordError = null});
  

@override@JsonKey() final  ChangePasswordStatus status;
@override@JsonKey() final  MasterPasswordValue oldPassword;
@override@JsonKey() final  MasterPasswordValue newPassword;
@override@JsonKey() final  ConfirmMasterPasswordValue confirmNewPassword;
@override@JsonKey() final  MasterPasswordValueError? oldPasswordError;
@override@JsonKey() final  MasterPasswordValueError? newPasswordError;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePasswordStateCopyWith<_ChangePasswordState> get copyWith => __$ChangePasswordStateCopyWithImpl<_ChangePasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePasswordState&&(identical(other.status, status) || other.status == status)&&(identical(other.oldPassword, oldPassword) || other.oldPassword == oldPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.confirmNewPassword, confirmNewPassword) || other.confirmNewPassword == confirmNewPassword)&&(identical(other.oldPasswordError, oldPasswordError) || other.oldPasswordError == oldPasswordError)&&(identical(other.newPasswordError, newPasswordError) || other.newPasswordError == newPasswordError));
}


@override
int get hashCode => Object.hash(runtimeType,status,oldPassword,newPassword,confirmNewPassword,oldPasswordError,newPasswordError);

@override
String toString() {
  return 'ChangePasswordState(status: $status, oldPassword: $oldPassword, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword, oldPasswordError: $oldPasswordError, newPasswordError: $newPasswordError)';
}


}

/// @nodoc
abstract mixin class _$ChangePasswordStateCopyWith<$Res> implements $ChangePasswordStateCopyWith<$Res> {
  factory _$ChangePasswordStateCopyWith(_ChangePasswordState value, $Res Function(_ChangePasswordState) _then) = __$ChangePasswordStateCopyWithImpl;
@override @useResult
$Res call({
 ChangePasswordStatus status, MasterPasswordValue oldPassword, MasterPasswordValue newPassword, ConfirmMasterPasswordValue confirmNewPassword, MasterPasswordValueError? oldPasswordError, MasterPasswordValueError? newPasswordError
});




}
/// @nodoc
class __$ChangePasswordStateCopyWithImpl<$Res>
    implements _$ChangePasswordStateCopyWith<$Res> {
  __$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final _ChangePasswordState _self;
  final $Res Function(_ChangePasswordState) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? oldPassword = null,Object? newPassword = null,Object? confirmNewPassword = null,Object? oldPasswordError = freezed,Object? newPasswordError = freezed,}) {
  return _then(_ChangePasswordState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChangePasswordStatus,oldPassword: null == oldPassword ? _self.oldPassword : oldPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as MasterPasswordValue,confirmNewPassword: null == confirmNewPassword ? _self.confirmNewPassword : confirmNewPassword // ignore: cast_nullable_to_non_nullable
as ConfirmMasterPasswordValue,oldPasswordError: freezed == oldPasswordError ? _self.oldPasswordError : oldPasswordError // ignore: cast_nullable_to_non_nullable
as MasterPasswordValueError?,newPasswordError: freezed == newPasswordError ? _self.newPasswordError : newPasswordError // ignore: cast_nullable_to_non_nullable
as MasterPasswordValueError?,
  ));
}


}

// dart format on
