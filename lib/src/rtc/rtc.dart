import '../config/config.dart';
import 'config.dart' show rtcConfig;

class _RTC {
  _RTC();

  rtcConfig getConfig() {
    return config.rtc;
  }
}

_RTC _cachedRTC;

_RTC get rtc => _cachedRTC ??= _RTC();
