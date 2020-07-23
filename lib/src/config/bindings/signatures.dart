import 'dart:ffi';
import 'package:ffi/ffi.dart';

typedef decrypt_native_t = Pointer<Utf8> Function(
  Pointer<Utf8> appID,
  Pointer<Utf8> cipherText,
);

typedef release_native_t = Pointer<Utf8> Function(
  Pointer<Utf8> plainText,
);
