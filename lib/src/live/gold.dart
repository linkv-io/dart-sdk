part of 'live.dart';

Future<Map<String, dynamic>> _changeGoldByLiveOpenID(live o, String liveOpenID,
    String uniqueID, OrderType typ, int gold, int expr, String optionalReason) {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
    'request_id': uniqueID,
    'type': (typ.index + 1).toString(),
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
  return http().PostDataWithHeader(uri, params).then((response) {
    if (response.statusCode != 200) {
      return Future.value({
        'status': false,
        'error': 'httpStatusCode(${response.statusCode}) != 200',
      });
    }

    Map<String, dynamic> result = json.decode(response.data);
    if (int.tryParse(result['status']) != 200) {
      return Future.value({
        'status': false,
        'error': 'message(${result['msg']})',
      });
    }
    return Future.value({
      'status': true,
    });
  });
}

Future<Map<String, dynamic>> _getGoldByLiveOpenID(live o, String liveOpenID) {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
  };
  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/finanv0/getUserTokens';

  return http().PostDataWithHeader(uri, params).then((response) {
    if (response.statusCode != 200) {
      return Future.value({
        'status': false,
        'error': 'httpStatusCode(${response.statusCode}) != 200',
      });
    }

    Map<String, dynamic> result = json.decode(response.data);
    if (int.tryParse(result['status']) != 200) {
      return Future.value({
        'status': false,
        'error': 'message(${result['msg']})',
      });
    }

    Map<String, dynamic> data = result['data'];

    return Future.value({
      'status': true,
      'golds': int.tryParse(data['livemeTokens']),
    });
  });
}
