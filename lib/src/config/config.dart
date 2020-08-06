import 'dart:convert' show json;
import 'package:ffi/ffi.dart';
import 'package:linkv_sdk/src/live/live.dart';
import 'bindings/bindings.dart';

import '../im/config.dart' show imConfig;
import '../rtc/config.dart' show rtcConfig;
import '../live/config.dart' show liveConfig;

class _Config {
  imConfig im;
  rtcConfig rtc;
  liveConfig live;

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
    bindings.release(plain);
    return plainText;
  }

  void _parseConfig(String jsonData) {
    var jsonMap = json.decode(jsonData);
    im = imConfig.fromJson(
      Map<String, dynamic>.from(jsonMap['im'] ?? {}),
    );
    rtc = rtcConfig.fromJson(
      Map<String, dynamic>.from(jsonMap['rtc'] ?? {}),
    );
    live = liveConfig.fromJson(
      Map<String, dynamic>.from(jsonMap['sensor'] ?? {}),
    );
  }
}

_Config _cachedConfig;

_Config get config => _cachedConfig ??= _Config();
