part of 'live.dart';

Future<Map<String, dynamic>> _successOrderByLiveOpenID(
    live o,
    String liveOpenID,
    String uniqueID,
    OrderType typ,
    int gold,
    int money,
    int expr,
    PlatformType plat,
    String optionalOrderID) async {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'uid': liveOpenID,
    'request_id': uniqueID,
    'type': (typ.index + 1).toString(),
    'value': gold.toString(),
    'money': money.toString(),
    'expriation':
        ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + expr * 86400)
            .toString(),
    'channel': o.GetConfig().alias,
    'platform': _getPlatformType(plat),
  };

  if (optionalOrderID.isNotEmpty) {
    params['order_id'] = optionalOrderID;
  }

  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/finanv0/orderSuccess';

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
