part of 'im.dart';

Future<Map<String, String>> _PushConverseData(
    im o,
    fromUserId,
    toUserId,
    content,
    objectName,
    pushContent,
    pushData,
    deviceId,
    toUserAppid,
    toUserExtSysUserId,
    isCheckSensitiveWords) async {
  var nonce = _genRandomString();
  var timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  Map params = <String, String>{
    'objectName': objectName,
    'pushContent': pushContent,
    'pushData': pushData,
    'deviceId': deviceId,
    'toUserAppid': toUserAppid,
    'toUserExtSysUserId': toUserExtSysUserId,
    'isCheckSensitiveWords': isCheckSensitiveWords,
    'appId': o.getConfig().appID,
  };

  if (fromUserId.isNotEmpty) {
    params['fromUserId'] = fromUserId;
  }

  if (toUserId.isNotEmpty) {
    params['toUserId'] = toUserId;
  }

  if (content.isNotEmpty) {
    params['content'] = content;
  }

  Map headers = <String, String>{
    'appId': o.getConfig().appID,
    'appkey': o.getConfig().appKey,
    'cmimToken':
        _cmimToken([nonce, o.getConfig().appSecret, timestamp.toString()]),
    'timestamp': timestamp.toString(),
    'nonce': nonce,
    'sign': _sign(
        '${o.getConfig().appID}|${o.getConfig().appKey}|${timestamp}|${nonce}'),
  };

  var uri = o.getConfig().url + '/api/rest/message/converse/pushConverseData';

  var response = await http().PostDataWithHeader(uri, params, headers: headers);

  if (response.data['code'] != 200) {
    return {
      'status': response.data['code'],
      'error': response.data['msg'],
    };
  }

  if (response.data['code'] == 200) {
    return {
      'status': '200',
      'msg': response.data['msg'],
      'requestID': response.data['requestID'],
    };
  }
}
