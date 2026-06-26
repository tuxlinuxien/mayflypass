// This is a generated file - do not edit.
//
// Generated from storage.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'totp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum Storage_Item { totp, notSet }

class Storage extends $pb.GeneratedMessage {
  factory Storage({
    $0.Totp? totp,
  }) {
    final result = create();
    if (totp != null) result.totp = totp;
    return result;
  }

  Storage._();

  factory Storage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Storage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Storage_Item> _Storage_ItemByTag = {
    1: Storage_Item.totp,
    0: Storage_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Storage',
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<$0.Totp>(1, _omitFieldNames ? '' : 'totp', subBuilder: $0.Totp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Storage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Storage copyWith(void Function(Storage) updates) =>
      super.copyWith((message) => updates(message as Storage)) as Storage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Storage create() => Storage._();
  @$core.override
  Storage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Storage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Storage>(create);
  static Storage? _defaultInstance;

  @$pb.TagNumber(1)
  Storage_Item whichItem() => _Storage_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $0.Totp get totp => $_getN(0);
  @$pb.TagNumber(1)
  set totp($0.Totp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotp() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Totp ensureTotp() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
