import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

bool isEmpty(String string) {
  return string.trim().isEmpty;
}

String formatAmount(num amount) {
  return NumberFormat.currency(name: '').format(amount);
}

String getEncryptedData(String str, String key) {
  final paddedKey = key.padRight(24, '0').substring(0, 24); // 24-byte key
  final iv = encrypt.IV.fromLength(8); // Default 8-byte IV (zeros)

  final encrypter = encrypt.Encrypter(
    encrypt.ThreeDES(
      encrypt.Key.fromUtf8(paddedKey),
      mode: encrypt.ThreeDESMode.ecb,
      padding: null,
    ),
  );

  final encrypted = encrypter.encrypt(str, iv: iv);
  return encrypted.base64;
}

String cleanUrl(String url) {
  return url.replaceAll(RegExp(r"[\n\r\s]+"), "");
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

putIfNotNull({@required Map map, @required key, @required value}) {
  if (value == null || (value is String && value.isEmpty)) return;
  map[key] = value;
}

putIfTrue({@required Map map, @required key, @required bool value}) {
  if (value == null || !value) return;
  map[key] = value;
}

printWrapped(Object text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text?.toString() ?? '').forEach(
        (match) => debugPrint(match.group(0)),
      );
}
