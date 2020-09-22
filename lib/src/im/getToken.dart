part of 'im.dart';

Future<Map<String, String>> _getToken(im o, String userId) async {
  var nonce = _genRandomString();
  var timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  var params = {'userId': userId};

  // ignore: omit_local_variable_types
  Map<String, String> headers = {
    'nonce': nonce,
    'cmimToken': _cmimToken([nonce, o.getConfig().appSecret, timestamp.toString()]),
    'sign': _sign('${o.getConfig().appID}|${o.getConfig().appKey}|${timestamp}|${nonce}'),
    'appkey': o.getConfig().appKey,
    'timestamp': timestamp.toString(),
    'appUid': userId,
    'appId': o.getConfig().appID,
    'signature': _cmimToken([nonce, o.getConfig().appSecret, timestamp.toString()]),
  };

  var uri = o.getConfig().url + '/api/rest/getToken';

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
      'token': response.data['token'],
    };
  }
}
