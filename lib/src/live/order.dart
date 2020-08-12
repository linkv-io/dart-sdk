part of 'live.dart';

Future<Map<String, dynamic>> _successOrderByLiveOpenID(
    live o,
    String liveOpenID,
    int orderType,
    int gold,
    int money,
    int expr,
    String platformType,
    String optionalOrderID) async {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
    'request_id': _genUniqueIDString(),
    'type': orderType.toString(),
    'value': gold.toString(),
    'money': money.toString(),
    'expriation':
        ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + expr * 86400)
            .toString(),
    'channel': o.GetConfig().alias,
    'platform': platformType,
  };

  if (optionalOrderID.isNotEmpty) {
    params['order_id'] = optionalOrderID;
  }

  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/finanv0/orderSuccess';

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
