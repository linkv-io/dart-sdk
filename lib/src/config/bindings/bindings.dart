import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'signatures.dart';
import 'ffi.dart';

class _Bindings {
  DynamicLibrary core;

  Pointer<Utf8> Function(
    Pointer<Utf8> appID,
    Pointer<Utf8> cipherText,
  ) decrypt;

  _Bindings() {
    core = dlopenPlatformSpecific(FILE);

    decrypt =
        core.lookup<NativeFunction<decrypt_native_t>>('decrypt').asFunction();
  }
}

_Bindings _cachedBindings;

_Bindings get bindings => _cachedBindings ??= _Bindings();

const VERSION = '0.0.2';
const FILE = 'decrypt';

Future<bool> get downloadLibrary => download(FILE,version: VERSION);