import '../config/config.dart';
import 'config.dart' show rtcConfig;

abstract class LvRTC {
  factory LvRTC() => rtc._();
}

class rtc implements LvRTC {
  rtc._();

  rtcConfig getConfig() {
    return config.rtc;
  }
}
