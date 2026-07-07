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
mixin _$TotpState {

 TotpStatus get status; UuidValue get id; TotpIssuerValue get issuer; TotpAccountValue get account; TotpSecretValue get secret;
/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotpStateCopyWith<TotpState> get copyWith => _$TotpStateCopyWithImpl<TotpState>(this as TotpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotpState&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.account, account) || other.account == account)&&(identical(other.secret, secret) || other.secret == secret));
}


@override
int get hashCode => Object.hash(runtimeType,status,id,issuer,account,secret);

@override
String toString() {
  return 'TotpState(status: $status, id: $id, issuer: $issuer, account: $account, secret: $secret)';
}


}

/// @nodoc
abstract mixin class $TotpStateCopyWith<$Res>  {
  factory $TotpStateCopyWith(TotpState value, $Res Function(TotpState) _then) = _$TotpStateCopyWithImpl;
@useResult
$Res call({
 TotpStatus status, UuidValue id, TotpIssuerValue issuer, TotpAccountValue account, TotpSecretValue secret
});




}
/// @nodoc
class _$TotpStateCopyWithImpl<$Res>
    implements $TotpStateCopyWith<$Res> {
  _$TotpStateCopyWithImpl(this._self, this._then);

  final TotpState _self;
  final $Res Function(TotpState) _then;

/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? id = null,Object? issuer = null,Object? account = null,Object? secret = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TotpStatus,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UuidValue,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as TotpIssuerValue,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as TotpAccountValue,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as TotpSecretValue,
  ));
}

}


/// Adds pattern-matching-related methods to [TotpState].
extension TotpStatePatterns on TotpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotpState value)  $default,){
final _that = this;
switch (_that) {
case _TotpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotpState value)?  $default,){
final _that = this;
switch (_that) {
case _TotpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TotpStatus status,  UuidValue id,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotpState() when $default != null:
return $default(_that.status,_that.id,_that.issuer,_that.account,_that.secret);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TotpStatus status,  UuidValue id,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret)  $default,) {final _that = this;
switch (_that) {
case _TotpState():
return $default(_that.status,_that.id,_that.issuer,_that.account,_that.secret);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TotpStatus status,  UuidValue id,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret)?  $default,) {final _that = this;
switch (_that) {
case _TotpState() when $default != null:
return $default(_that.status,_that.id,_that.issuer,_that.account,_that.secret);case _:
  return null;

}
}

}

/// @nodoc


class _TotpState implements TotpState {
  const _TotpState({this.status = TotpStatus.loading, required this.id, this.issuer = const TotpIssuerValue.pure(), this.account = const TotpAccountValue.pure(), this.secret = const TotpSecretValue.pure()});
  

@override@JsonKey() final  TotpStatus status;
@override final  UuidValue id;
@override@JsonKey() final  TotpIssuerValue issuer;
@override@JsonKey() final  TotpAccountValue account;
@override@JsonKey() final  TotpSecretValue secret;

/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotpStateCopyWith<_TotpState> get copyWith => __$TotpStateCopyWithImpl<_TotpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotpState&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.account, account) || other.account == account)&&(identical(other.secret, secret) || other.secret == secret));
}


@override
int get hashCode => Object.hash(runtimeType,status,id,issuer,account,secret);

@override
String toString() {
  return 'TotpState(status: $status, id: $id, issuer: $issuer, account: $account, secret: $secret)';
}


}

/// @nodoc
abstract mixin class _$TotpStateCopyWith<$Res> implements $TotpStateCopyWith<$Res> {
  factory _$TotpStateCopyWith(_TotpState value, $Res Function(_TotpState) _then) = __$TotpStateCopyWithImpl;
@override @useResult
$Res call({
 TotpStatus status, UuidValue id, TotpIssuerValue issuer, TotpAccountValue account, TotpSecretValue secret
});




}
/// @nodoc
class __$TotpStateCopyWithImpl<$Res>
    implements _$TotpStateCopyWith<$Res> {
  __$TotpStateCopyWithImpl(this._self, this._then);

  final _TotpState _self;
  final $Res Function(_TotpState) _then;

/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? id = null,Object? issuer = null,Object? account = null,Object? secret = null,}) {
  return _then(_TotpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TotpStatus,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UuidValue,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as TotpIssuerValue,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as TotpAccountValue,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as TotpSecretValue,
  ));
}


}

// dart format on
