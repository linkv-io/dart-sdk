import 'dart:convert' show json;
import 'package:ffi/ffi.dart';
import 'bindings/bindings.dart';

import '../im/config.dart' show imConfig;
import '../rtc/config.dart' show rtcConfig;

class _Config {
  imConfig im;
  rtcConfig rtc;

  _Config();

  Future<bool> init(String appID, String appSecret) =>
      downloadLibrary.then((value) {
        if (!value) {
          return Future.value(false);
        }
        _parseConfig(_parseSecret(appID, appSecret));
        return Future.value(true);
      });

  String _parseSecret(String appID, String appSecret) {
    var plain = bindings.decrypt(Utf8.toUtf8(appID), Utf8.toUtf8(appSecret));
    var plainText = Utf8.fromUtf8(plain);
    free(plain);
    return plainText;
  }

  void _parseConfig(String jsonData) {
    print('json:${jsonData}\n');
    var jsonMap = json.decode(jsonData);
    im = imConfig.fromJson(Map<String, dynamic>.from(jsonMap['im'] ?? {}));
    rtc = rtcConfig.fromJson(Map<String, dynamic>.from(jsonMap['rtc'] ?? {}));
  }
}

_Config _cachedConfig;

_Config get config => _cachedConfig ??= _Config();
