library linkv_sdk;

export 'src/im/im.dart';
export 'src/rtc/rtc.dart';

import 'src/config/config.dart';

Future<bool> init(String appID, String appSecret) {
  return config.init(appID, appSecret);
}
