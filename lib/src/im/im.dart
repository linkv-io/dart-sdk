import '../config/config.dart';
import 'config.dart' show imConfig;
import 'dart:io';
import 'dart:math';
import 'dart:convert' show json;
import 'package:convert/convert.dart';
import '../http/http.dart' show http;
import 'package:crypto/crypto.dart';

import 'dart:convert';

part 'getToken.dart';
part 'pushConverseData.dart';

abstract class LvIM {
  factory LvIM() => im._();

  external Future<Map<String, String>> GetToken(String userId);

  external Future<Map<String, String>> PushConverseData(
      String fromUserId, String toUserId, String content,
      {String objectName = '',
      String pushContent = '',
      String pushData = '',
      String deviceId = '',
      String toUserAppid = '',
      String toUserExtSysUserId = '',
      String isCheckSensitiveWords = ''});
}

class im implements LvIM {
  im._();

  imConfig getConfig() {
    return config.im;
  }

  @override
  Future<Map<String, String>> GetToken(String userId) =>
      _getToken(this, userId);

  @override
  Future<Map<String, String>> PushConverseData(
      String fromUserId, String toUserId, String content,
      {String objectName = '',
        String pushContent = '',
        String pushData = '',
        String deviceId = '',
        String toUserAppid = '',
        String toUserExtSysUserId = '',
        String isCheckSensitiveWords = ''}) =>
      _PushConverseData(this, fromUserId, toUserId, content, objectName, pushContent, pushData, deviceId, toUserAppid, toUserExtSysUserId, isCheckSensitiveWords);
}

String _genRandomString() {
  var nLen = 8;
  var str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

  /// 生成的字符串固定长度
  var container = '';
  for (var i = 0; i < nLen; i++) {
    container += str[Random().nextInt(str.length)];
    if (i == 7) {
      container += (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    }
  }
  return container;
}

String _cmimToken(List<String> list) {
  var sign = '';
  list.sort();
  list.forEach((item) => sign += item);
  var content = Utf8Encoder().convert(sign);
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

String _sign(String str) {
  var content = Utf8Encoder().convert(str);
  var digest = sha1.convert(content);
  return hex.encode(digest.bytes).toUpperCase();
}
