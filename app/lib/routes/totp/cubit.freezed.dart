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

 TotpStatus get status; UuidValue get id; int get createdAtMs; TotpIssuerValue get issuer; TotpAccountValue get account; TotpSecretValue get secret; TotpAlgorithm get algorithm; int get digits; int get period; bool get favorite; List<String> get tags;
/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotpStateCopyWith<TotpState> get copyWith => _$TotpStateCopyWithImpl<TotpState>(this as TotpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotpState&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.account, account) || other.account == account)&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.digits, digits) || other.digits == digits)&&(identical(other.period, period) || other.period == period)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,status,id,createdAtMs,issuer,account,secret,algorithm,digits,period,favorite,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'TotpState(status: $status, id: $id, createdAtMs: $createdAtMs, issuer: $issuer, account: $account, secret: $secret, algorithm: $algorithm, digits: $digits, period: $period, favorite: $favorite, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $TotpStateCopyWith<$Res>  {
  factory $TotpStateCopyWith(TotpState value, $Res Function(TotpState) _then) = _$TotpStateCopyWithImpl;
@useResult
$Res call({
 TotpStatus status, UuidValue id, int createdAtMs, TotpIssuerValue issuer, TotpAccountValue account, TotpSecretValue secret, TotpAlgorithm algorithm, int digits, int period, bool favorite, List<String> tags
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
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? id = null,Object? createdAtMs = null,Object? issuer = null,Object? account = null,Object? secret = null,Object? algorithm = null,Object? digits = null,Object? period = null,Object? favorite = null,Object? tags = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TotpStatus,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UuidValue,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as TotpIssuerValue,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as TotpAccountValue,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as TotpSecretValue,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as TotpAlgorithm,digits: null == digits ? _self.digits : digits // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TotpStatus status,  UuidValue id,  int createdAtMs,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret,  TotpAlgorithm algorithm,  int digits,  int period,  bool favorite,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotpState() when $default != null:
return $default(_that.status,_that.id,_that.createdAtMs,_that.issuer,_that.account,_that.secret,_that.algorithm,_that.digits,_that.period,_that.favorite,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TotpStatus status,  UuidValue id,  int createdAtMs,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret,  TotpAlgorithm algorithm,  int digits,  int period,  bool favorite,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _TotpState():
return $default(_that.status,_that.id,_that.createdAtMs,_that.issuer,_that.account,_that.secret,_that.algorithm,_that.digits,_that.period,_that.favorite,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TotpStatus status,  UuidValue id,  int createdAtMs,  TotpIssuerValue issuer,  TotpAccountValue account,  TotpSecretValue secret,  TotpAlgorithm algorithm,  int digits,  int period,  bool favorite,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _TotpState() when $default != null:
return $default(_that.status,_that.id,_that.createdAtMs,_that.issuer,_that.account,_that.secret,_that.algorithm,_that.digits,_that.period,_that.favorite,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _TotpState implements TotpState {
  const _TotpState({this.status = TotpStatus.loading, required this.id, required this.createdAtMs, this.issuer = const TotpIssuerValue.pure(), this.account = const TotpAccountValue.pure(), this.secret = const TotpSecretValue.pure(), this.algorithm = TotpAlgorithm.SHA1, this.digits = 6, this.period = 30, this.favorite = false, final  List<String> tags = const []}): _tags = tags;
  

@override@JsonKey() final  TotpStatus status;
@override final  UuidValue id;
@override final  int createdAtMs;
@override@JsonKey() final  TotpIssuerValue issuer;
@override@JsonKey() final  TotpAccountValue account;
@override@JsonKey() final  TotpSecretValue secret;
@override@JsonKey() final  TotpAlgorithm algorithm;
@override@JsonKey() final  int digits;
@override@JsonKey() final  int period;
@override@JsonKey() final  bool favorite;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of TotpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotpStateCopyWith<_TotpState> get copyWith => __$TotpStateCopyWithImpl<_TotpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotpState&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAtMs, createdAtMs) || other.createdAtMs == createdAtMs)&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.account, account) || other.account == account)&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.digits, digits) || other.digits == digits)&&(identical(other.period, period) || other.period == period)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,status,id,createdAtMs,issuer,account,secret,algorithm,digits,period,favorite,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'TotpState(status: $status, id: $id, createdAtMs: $createdAtMs, issuer: $issuer, account: $account, secret: $secret, algorithm: $algorithm, digits: $digits, period: $period, favorite: $favorite, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$TotpStateCopyWith<$Res> implements $TotpStateCopyWith<$Res> {
  factory _$TotpStateCopyWith(_TotpState value, $Res Function(_TotpState) _then) = __$TotpStateCopyWithImpl;
@override @useResult
$Res call({
 TotpStatus status, UuidValue id, int createdAtMs, TotpIssuerValue issuer, TotpAccountValue account, TotpSecretValue secret, TotpAlgorithm algorithm, int digits, int period, bool favorite, List<String> tags
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
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? id = null,Object? createdAtMs = null,Object? issuer = null,Object? account = null,Object? secret = null,Object? algorithm = null,Object? digits = null,Object? period = null,Object? favorite = null,Object? tags = null,}) {
  return _then(_TotpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TotpStatus,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as UuidValue,createdAtMs: null == createdAtMs ? _self.createdAtMs : createdAtMs // ignore: cast_nullable_to_non_nullable
as int,issuer: null == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as TotpIssuerValue,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as TotpAccountValue,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as TotpSecretValue,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as TotpAlgorithm,digits: null == digits ? _self.digits : digits // ignore: cast_nullable_to_non_nullable
as int,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as int,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
