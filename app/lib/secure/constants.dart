import 'dart:convert';
import 'package:cryptography_plus/cryptography_plus.dart';

// DO NOT MODIFY THESE VALUES IF YOU ALREADY HAVE CREATED AN ACCOUNT
// OR YOU WILL NEVER BE ABLE TO LOGIN NOR DECRYPT THE STORAGE.

final secretKeyLength = Xchacha20.poly1305Aead().secretKeyLength;

final authSalt = utf8.encode('domain/derive/auth');
final authIterations = 1000;
final authBits = secretKeyLength * 8; // into bits
final kekSalt = utf8.encode('domain/derive/kek');
final kekIterations = 1000;
final kekBits = secretKeyLength * 8; // into bits

final masterPasswordMemCost = 64 * 1024;
final masterPasswordICost = 4;
final masterPasswordPCost = 3;
final masterPasswordOutputLen = secretKeyLength;
