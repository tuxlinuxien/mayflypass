// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 SettingsStatus get status; String? get email; Duration? get lockoutAfter; bool? get biometricUnlock; bool? get biometricUnlockAvailable;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.lockoutAfter, lockoutAfter) || other.lockoutAfter == lockoutAfter)&&(identical(other.biometricUnlock, biometricUnlock) || other.biometricUnlock == biometricUnlock)&&(identical(other.biometricUnlockAvailable, biometricUnlockAvailable) || other.biometricUnlockAvailable == biometricUnlockAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,status,email,lockoutAfter,biometricUnlock,biometricUnlockAvailable);

@override
String toString() {
  return 'SettingsState(status: $status, email: $email, lockoutAfter: $lockoutAfter, biometricUnlock: $biometricUnlock, biometricUnlockAvailable: $biometricUnlockAvailable)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 SettingsStatus status, String? email, Duration? lockoutAfter, bool? biometricUnlock, bool? biometricUnlockAvailable
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? email = freezed,Object? lockoutAfter = freezed,Object? biometricUnlock = freezed,Object? biometricUnlockAvailable = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettingsStatus,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,lockoutAfter: freezed == lockoutAfter ? _self.lockoutAfter : lockoutAfter // ignore: cast_nullable_to_non_nullable
as Duration?,biometricUnlock: freezed == biometricUnlock ? _self.biometricUnlock : biometricUnlock // ignore: cast_nullable_to_non_nullable
as bool?,biometricUnlockAvailable: freezed == biometricUnlockAvailable ? _self.biometricUnlockAvailable : biometricUnlockAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SettingsStatus status,  String? email,  Duration? lockoutAfter,  bool? biometricUnlock,  bool? biometricUnlockAvailable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.email,_that.lockoutAfter,_that.biometricUnlock,_that.biometricUnlockAvailable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SettingsStatus status,  String? email,  Duration? lockoutAfter,  bool? biometricUnlock,  bool? biometricUnlockAvailable)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.status,_that.email,_that.lockoutAfter,_that.biometricUnlock,_that.biometricUnlockAvailable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SettingsStatus status,  String? email,  Duration? lockoutAfter,  bool? biometricUnlock,  bool? biometricUnlockAvailable)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.status,_that.email,_that.lockoutAfter,_that.biometricUnlock,_that.biometricUnlockAvailable);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({this.status = SettingsStatus.loading, this.email = null, this.lockoutAfter = null, this.biometricUnlock = null, this.biometricUnlockAvailable = null});
  

@override@JsonKey() final  SettingsStatus status;
@override@JsonKey() final  String? email;
@override@JsonKey() final  Duration? lockoutAfter;
@override@JsonKey() final  bool? biometricUnlock;
@override@JsonKey() final  bool? biometricUnlockAvailable;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.status, status) || other.status == status)&&(identical(other.email, email) || other.email == email)&&(identical(other.lockoutAfter, lockoutAfter) || other.lockoutAfter == lockoutAfter)&&(identical(other.biometricUnlock, biometricUnlock) || other.biometricUnlock == biometricUnlock)&&(identical(other.biometricUnlockAvailable, biometricUnlockAvailable) || other.biometricUnlockAvailable == biometricUnlockAvailable));
}


@override
int get hashCode => Object.hash(runtimeType,status,email,lockoutAfter,biometricUnlock,biometricUnlockAvailable);

@override
String toString() {
  return 'SettingsState(status: $status, email: $email, lockoutAfter: $lockoutAfter, biometricUnlock: $biometricUnlock, biometricUnlockAvailable: $biometricUnlockAvailable)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 SettingsStatus status, String? email, Duration? lockoutAfter, bool? biometricUnlock, bool? biometricUnlockAvailable
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? email = freezed,Object? lockoutAfter = freezed,Object? biometricUnlock = freezed,Object? biometricUnlockAvailable = freezed,}) {
  return _then(_SettingsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SettingsStatus,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,lockoutAfter: freezed == lockoutAfter ? _self.lockoutAfter : lockoutAfter // ignore: cast_nullable_to_non_nullable
as Duration?,biometricUnlock: freezed == biometricUnlock ? _self.biometricUnlock : biometricUnlock // ignore: cast_nullable_to_non_nullable
as bool?,biometricUnlockAvailable: freezed == biometricUnlockAvailable ? _self.biometricUnlockAvailable : biometricUnlockAvailable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
