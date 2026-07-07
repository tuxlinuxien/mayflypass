// This is a generated file - do not edit.
//
// Generated from databox.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'databox.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'databox.pbenum.dart';

class Totp extends $pb.GeneratedMessage {
  factory Totp({
    $core.String? issuer,
    $core.String? account,
    $core.String? secret,
    TotpAlgorithm? algorithm,
    $core.int? digits,
    $core.int? period,
    $core.bool? favorite,
    $fixnum.Int64? createdAtMs,
    $core.Iterable<$core.String>? tags,
  }) {
    final result = create();
    if (issuer != null) result.issuer = issuer;
    if (account != null) result.account = account;
    if (secret != null) result.secret = secret;
    if (algorithm != null) result.algorithm = algorithm;
    if (digits != null) result.digits = digits;
    if (period != null) result.period = period;
    if (favorite != null) result.favorite = favorite;
    if (createdAtMs != null) result.createdAtMs = createdAtMs;
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  Totp._();

  factory Totp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Totp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Totp',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issuer')
    ..aOS(2, _omitFieldNames ? '' : 'account')
    ..aOS(3, _omitFieldNames ? '' : 'secret')
    ..aE<TotpAlgorithm>(4, _omitFieldNames ? '' : 'algorithm',
        enumValues: TotpAlgorithm.values)
    ..aI(5, _omitFieldNames ? '' : 'digits', defaultOrMaker: 6)
    ..aI(6, _omitFieldNames ? '' : 'period', defaultOrMaker: 30)
    ..aOB(7, _omitFieldNames ? '' : 'favorite')
    ..aInt64(8, _omitFieldNames ? '' : 'createdAtMs')
    ..pPS(9, _omitFieldNames ? '' : 'tags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Totp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Totp copyWith(void Function(Totp) updates) =>
      super.copyWith((message) => updates(message as Totp)) as Totp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Totp create() => Totp._();
  @$core.override
  Totp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Totp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Totp>(create);
  static Totp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issuer => $_getSZ(0);
  @$pb.TagNumber(1)
  set issuer($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssuer() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssuer() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get account => $_getSZ(1);
  @$pb.TagNumber(2)
  set account($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get secret => $_getSZ(2);
  @$pb.TagNumber(3)
  set secret($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSecret() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecret() => $_clearField(3);

  @$pb.TagNumber(4)
  TotpAlgorithm get algorithm => $_getN(3);
  @$pb.TagNumber(4)
  set algorithm(TotpAlgorithm value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAlgorithm() => $_has(3);
  @$pb.TagNumber(4)
  void clearAlgorithm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get digits => $_getI(4, 6);
  @$pb.TagNumber(5)
  set digits($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDigits() => $_has(4);
  @$pb.TagNumber(5)
  void clearDigits() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get period => $_getI(5, 30);
  @$pb.TagNumber(6)
  set period($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriod() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriod() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get favorite => $_getBF(6);
  @$pb.TagNumber(7)
  set favorite($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFavorite() => $_has(6);
  @$pb.TagNumber(7)
  void clearFavorite() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAtMs => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAtMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAtMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAtMs() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get tags => $_getList(8);
}

enum DataBox_Box { totp, notSet }

class DataBox extends $pb.GeneratedMessage {
  factory DataBox({
    Totp? totp,
  }) {
    final result = create();
    if (totp != null) result.totp = totp;
    return result;
  }

  DataBox._();

  factory DataBox.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DataBox.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DataBox_Box> _DataBox_BoxByTag = {
    1: DataBox_Box.totp,
    0: DataBox_Box.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DataBox',
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<Totp>(1, _omitFieldNames ? '' : 'totp', subBuilder: Totp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataBox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataBox copyWith(void Function(DataBox) updates) =>
      super.copyWith((message) => updates(message as DataBox)) as DataBox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataBox create() => DataBox._();
  @$core.override
  DataBox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DataBox getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataBox>(create);
  static DataBox? _defaultInstance;

  @$pb.TagNumber(1)
  DataBox_Box whichBox() => _DataBox_BoxByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearBox() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Totp get totp => $_getN(0);
  @$pb.TagNumber(1)
  set totp(Totp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotp() => $_clearField(1);
  @$pb.TagNumber(1)
  Totp ensureTotp() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
