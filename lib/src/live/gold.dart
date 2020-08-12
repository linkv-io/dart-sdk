part of 'live.dart';

Future<Map<String, dynamic>> _changeGoldByLiveOpenID(live o, String liveOpenID,
    int orderType, int gold, int expr, String optionalReason) async {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
    'request_id': _genUniqueIDString(),
    'type': orderType.toString(),
    'value': gold.toString(),
    'expriation':
        ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + expr * 86400)
            .toString(),
  };

  if (optionalReason.isNotEmpty) {
    params['reason'] = optionalReason;
  }

  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/finanv0/changeGold';
  var errResult = '';

  for (var i = 0; i < 3; i++) {
    var response = await http().PostDataWithHeader(uri, params);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': 'httpStatusCode(${response.statusCode}) != 200',
      };
    }

    Map<String, dynamic> result = json.decode(response.data);
    if (int.tryParse(result['status']) == 200) {
      return {
        'status': true,
      };
    }

    if (int.tryParse(result['status']) == 500) {
      errResult = 'message(${result['msg']})';
      sleep(waitTime);
      continue;
    }

    return {
      'status': false,
      'error': 'message(${result['msg']})',
    };
  }

  return {
    'status': false,
    'error': errResult,
  };
}

Future<Map<String, dynamic>> _getGoldByLiveOpenID(
    live o, String liveOpenID) async {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
  };
  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/finanv0/getUserTokens';

  var errResult = '';

  for (var i = 0; i < 3; i++) {
    var response = await http().PostDataWithHeader(uri, params);
    if (response.statusCode != 200) {
      return {
        'status': false,
        'error': 'httpStatusCode(${response.statusCode}) != 200',
      };
    }

    Map<String, dynamic> result = json.decode(response.data);
    if (int.tryParse(result['status']) == 200) {
      Map<String, dynamic> data = result['data'];
      return {
        'status': true,
        'golds': int.tryParse(data['livemeTokens']),
      };
    }

    if (int.tryParse(result['status']) == 500) {
      errResult = 'message(${result['msg']})';
      sleep(waitTime);
      continue;
    }

    return {
      'status': false,
      'error': 'message(${result['msg']})',
    };
  }

  return {
    'status': false,
    'error': errResult,
  };
}
