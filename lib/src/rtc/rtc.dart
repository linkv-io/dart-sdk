import '../config/config.dart';
import 'package:crypto/crypto.dart';
import 'config.dart' show rtcConfig;

abstract class LvRTC {
  factory LvRTC() => rtc._();

  external Map<String, String> genAuth();
}

class rtc implements LvRTC {
  rtc._();

  rtcConfig getConfig() {
    return config.rtc;
  }

  @override
  Map<String, String> genAuth() {
    var now = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    var hmacSha256 = Hmac(sha1, getConfig().appKey.codeUnits); // HMAC-SHA256
    var digest = hmacSha256.convert((getConfig().appID + now).codeUnits);
    return <String, String>{
      'app_id': getConfig().appID,
      'auth': digest.toString(),
      'expire_ts': now,
    };
  }
}
