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

import 'package:protobuf/protobuf.dart' as $pb;

class TotpAlgorithm extends $pb.ProtobufEnum {
  static const TotpAlgorithm SHA1 =
      TotpAlgorithm._(0, _omitEnumNames ? '' : 'SHA1');
  static const TotpAlgorithm SHA256 =
      TotpAlgorithm._(1, _omitEnumNames ? '' : 'SHA256');
  static const TotpAlgorithm SHA512 =
      TotpAlgorithm._(2, _omitEnumNames ? '' : 'SHA512');

  static const $core.List<TotpAlgorithm> values = <TotpAlgorithm>[
    SHA1,
    SHA256,
    SHA512,
  ];

  static final $core.List<TotpAlgorithm?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TotpAlgorithm? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TotpAlgorithm._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
