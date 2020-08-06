library linkv_sdk;

import 'src/config/config.dart';
import 'src/http/http.dart' show http;
import 'src/im/im.dart';
import 'src/rtc/rtc.dart';
import 'src/live/live.dart';

export 'src/live/live.dart' show OrderType, PlatformType, SexType;

var version = '0.4.2';

Future<bool> init(String appID, String appSecret, {int httpPoolSize = 10}) {
  http(version: version, poolSize: httpPoolSize);
  return config.init(appID, appSecret);
}

LvIM newLvIM() {
  return LvIM();
}

LvRTC newLvRTC() {
  return LvRTC();
}

LvLIVE newLvLIVE() {
  return LvLIVE();
}
