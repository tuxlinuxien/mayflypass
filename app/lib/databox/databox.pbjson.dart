// This is a generated file - do not edit.
//
// Generated from databox.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use totpAlgorithmDescriptor instead')
const TotpAlgorithm$json = {
  '1': 'TotpAlgorithm',
  '2': [
    {'1': 'SHA1', '2': 0},
    {'1': 'SHA256', '2': 1},
    {'1': 'SHA512', '2': 2},
  ],
};

/// Descriptor for `TotpAlgorithm`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List totpAlgorithmDescriptor = $convert.base64Decode(
    'Cg1Ub3RwQWxnb3JpdGhtEggKBFNIQTEQABIKCgZTSEEyNTYQARIKCgZTSEE1MTIQAg==');

@$core.Deprecated('Use totpDescriptor instead')
const Totp$json = {
  '1': 'Totp',
  '2': [
    {'1': 'issuer', '3': 1, '4': 1, '5': 9, '10': 'issuer'},
    {'1': 'account', '3': 2, '4': 1, '5': 9, '10': 'account'},
    {'1': 'secret', '3': 3, '4': 1, '5': 9, '10': 'secret'},
    {
      '1': 'algorithm',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.TotpAlgorithm',
      '10': 'algorithm'
    },
    {'1': 'digits', '3': 5, '4': 1, '5': 5, '7': '6', '10': 'digits'},
    {'1': 'period', '3': 6, '4': 1, '5': 5, '7': '30', '10': 'period'},
    {'1': 'favorite', '3': 7, '4': 1, '5': 8, '10': 'favorite'},
    {'1': 'created_at_ms', '3': 8, '4': 1, '5': 3, '10': 'createdAtMs'},
  ],
};

/// Descriptor for `Totp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totpDescriptor = $convert.base64Decode(
    'CgRUb3RwEhYKBmlzc3VlchgBIAEoCVIGaXNzdWVyEhgKB2FjY291bnQYAiABKAlSB2FjY291bn'
    'QSFgoGc2VjcmV0GAMgASgJUgZzZWNyZXQSLAoJYWxnb3JpdGhtGAQgASgOMg4uVG90cEFsZ29y'
    'aXRobVIJYWxnb3JpdGhtEhkKBmRpZ2l0cxgFIAEoBToBNlIGZGlnaXRzEhoKBnBlcmlvZBgGIA'
    'EoBToCMzBSBnBlcmlvZBIaCghmYXZvcml0ZRgHIAEoCFIIZmF2b3JpdGUSIgoNY3JlYXRlZF9h'
    'dF9tcxgIIAEoA1ILY3JlYXRlZEF0TXM=');

@$core.Deprecated('Use dataBoxDescriptor instead')
const DataBox$json = {
  '1': 'DataBox',
  '2': [
    {'1': 'totp', '3': 1, '4': 1, '5': 11, '6': '.Totp', '9': 0, '10': 'totp'},
  ],
  '8': [
    {'1': 'box'},
  ],
};

/// Descriptor for `DataBox`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataBoxDescriptor = $convert.base64Decode(
    'CgdEYXRhQm94EhsKBHRvdHAYASABKAsyBS5Ub3RwSABSBHRvdHBCBQoDYm94');
