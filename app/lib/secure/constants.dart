import 'dart:convert';
import 'package:cryptography_plus/cryptography_plus.dart';

// DO NOT MODIFY THESE VALUES IF YOU ALREADY HAVE CREATED AN ACCOUNT
// OR YOU WILL NEVER BE ABLE TO LOGIN NOR DECRYPT THE STORAGE.

final secretKeyLength = Xchacha20.poly1305Aead().secretKeyLength;

final authSalt = utf8.encode('domain/derive/auth');
final authOuputLen = secretKeyLength;
final kekSalt = utf8.encode('domain/derive/kek');
final kekOuputLen = secretKeyLength;

final masterPasswordMemCost = 64 * 1024;
final masterPasswordICost = 15;
final masterPasswordPCost = 3;
final masterPasswordOutputLen = secretKeyLength;
