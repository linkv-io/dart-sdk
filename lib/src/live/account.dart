part of 'live.dart';

Future<Map<String, dynamic>> _getTokenByThirdUID(
    live o,
    String thirdUID,
    String aID,
    String userName,
    int sex,
    String portraitURI,
    String userEmail,
    String countryCode,
    String birthday) async {
  var params = {
    'nonce_str': _genRandomString(),
    'app_id': o.GetConfig().appKey,
    'userId': thirdUID,
    'aid': aID,
  };

  if (userName.isNotEmpty) {
    params['name'] = userName;
  }
  if (portraitURI.isNotEmpty) {
    params['portraitUri'] = portraitURI;
  }
  if (userEmail.isNotEmpty) {
    params['email'] = userEmail;
  }
  if (countryCode.isNotEmpty) {
    params['countryCode'] = countryCode;
  }
  if (birthday.isNotEmpty) {
    params['birthday'] = birthday;
  }
  if (sex != SexTypeUnknown) {
    params['sex'] = sex.toString();
  }

  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/v0/thGetToken';

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
        'liveToken': data['token'],
        'liveOpenID': data['openId'],
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
