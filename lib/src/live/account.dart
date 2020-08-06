part of 'live.dart';

Future<Map<String, dynamic>> _getTokenByThirdUID(
    live o,
    String thirdUID,
    String aID,
    String userName,
    SexType sex,
    String portraitURI,
    String userEmail,
    String countryCode,
    String birthday) {
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
  if (sex != SexType.Unknown) {
    params['sex'] = (sex.index - 1).toString();
  }

  params['sign'] = _genSign(params, o.GetConfig().appSecret);

  var uri = o.GetConfig().url + '/open/v0/thGetToken';

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
      'liveToken': data['token'],
      'liveOpenID': data['openId'],
    });
  });
}
