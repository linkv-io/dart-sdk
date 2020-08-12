import 'dart:io';
import 'dart:math';
import 'dart:convert' show json;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import '../http/http.dart' show http;
import '../config/config.dart';
import 'config.dart' show liveConfig;

part 'account.dart';

part 'order.dart';

part 'gold.dart';

int SexTypeUnknown = -1;
int SexTypeFemale = 0;
int SexTypeMale = 1;

int OrderTypeAdd = 1;
int OrderTypeDel = 2;
String PlatformTypeH5 = 'h5';
String PlatformTypeANDROID = 'android';
String PlatformTypeIOS = 'ios';

const waitTime = Duration(milliseconds: 300);

abstract class LvLIVE {
  factory LvLIVE() => live._();

  /// return {'status':true,'error':'','liveToken':'','liveOpenID':''}
  external Future<Map<String, dynamic>> GetTokenByThirdUID(
      String thirdUID, String aID,
      {String userName = '',
      int sex = -1,
      String portraitURI = '',
      String userEmail = '',
      String countryCode = '',
      String birthday = ''});

  /// return {'status':true,'error':'','golds':123}
  external Future<Map<String, dynamic>> SuccessOrderByLiveOpenID(
      String liveOpenID,
      int orderType,
      int gold,
      int money,
      int expr,
      String platformType,
      String orderID);

  /// return {'status':true,'error':''}
  external Future<Map<String, dynamic>> ChangeGoldByLiveOpenID(
      String liveOpenID, int orderType, int gold, int expr,
      {String optionalReason = ''});

  /// return {'status':true,'error':'','golds':123}
  external Future<Map<String, dynamic>> GetGoldByLiveOpenID(String liveOpenID);
}

class live implements LvLIVE {
  live._();

  liveConfig GetConfig() {
    return config.live;
  }

  @override
  Future<Map<String, dynamic>> GetTokenByThirdUID(String thirdUID, String aID,
          {String userName = '',
          int sex = -1,
          String portraitURI = '',
          String userEmail = '',
          String countryCode = '',
          String birthday = ''}) =>
      _getTokenByThirdUID(this, thirdUID, aID, userName, sex, portraitURI,
          userEmail, countryCode, birthday);

  @override
  Future<Map<String, dynamic>> SuccessOrderByLiveOpenID(
          String liveOpenID,
          int orderType,
          int gold,
          int money,
          int expr,
          String platformType,
          String orderID) =>
      _successOrderByLiveOpenID(this, liveOpenID, orderType, gold, money, expr,
          platformType, orderID);

  @override
  Future<Map<String, dynamic>> ChangeGoldByLiveOpenID(
          String liveOpenID, int orderType, int gold, int expr,
          {String optionalReason = ''}) =>
      _changeGoldByLiveOpenID(
          this, liveOpenID, orderType, gold, expr, optionalReason);

  @override
  Future<Map<String, dynamic>> GetGoldByLiveOpenID(String liveOpenID) =>
      _getGoldByLiveOpenID(this, liveOpenID);
}

String _genUniqueIDString() {
  var nLen = 32;
  var str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

  /// 生成的字符串固定长度
  var container = '';
  for (var i = 0; i < nLen; i++) {
    container += str[Random().nextInt(str.length)];
  }
  return container;
}

String _genRandomString() {
  var nLen = 16;
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

String _genSign(Map<String, String> params, String md5Secret) {
  var digest = md5.convert('${_encode(params)}&key=${md5Secret}'.codeUnits);
  return hex.encode(digest.bytes).toLowerCase();
}

String _encode(Map<String, String> params) {
  var container = '';
  var keys = params.keys.toList()..sort();
  for (var i = 0, m = keys.length; i < m; i++) {
    if (i != 0) {
      container += '&';
    }
    container += '${keys[i]}=${params[keys[i]]}';
  }
  return container;
}
