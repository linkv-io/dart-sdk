[![API Reference](https://img.shields.io/badge/api-reference-blue.svg)]()
[![Build Status](https://img.shields.io/static/v1?label=build&message=passing&color=32CD32)]()
[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-blue.svg)](https://github.com/linkv-io/dart-sdk/blob/master/LICENSE)

# dart-sdk

LINKV SDK for the dart programming language.

## Requirement

Dart >=2.5.0 && <3.0.0

## Installing

**pubspec.yaml** 
```sh
dependencies:
    linkv_sdk:
        git:
          url: git@github.com:linkv-io/dart-sdk.git
          ref: 0.4.4
```

```sh
pub get
```

## Usage

```dart
import 'package:linkv_sdk/linkv_sdk.dart' as linkv;

void main() async {
  var appID = 'rbaiHjNHQyVprPCBSHevvVvuNynNeTvp';
  var appSecret =
      '87EA975D424238D0A08F772321169816DD016667D5BB577EBAEB820516698416E4F94C28CB55E9FD8E010260E6C8A177C0B078FC098BCF2E9E7D4A9A71BF1EF8FBE49E05E5FC5A6A35C6550592C1DB96DF83F758EAFBC5B342D5D04C9D92B1A82A76E3756E83A4466DA22635A8A9F88901631B5BBBABC8A94577D66E8B000F4B179DA99BAA5E674E4F793D9E60EEF1C3B757006459ABB5E6315E370461EBC8E6B0A7523CA0032D33B5C0CF83264C9D83517C1C94CAB3F48B8D5062F5569D9793982455277C16F183DAE7B6C271F930A160A6CF07139712A9D3ABF85E05F8721B8BB6CAC1C23980227A1D5F31D23FA6567578AEEB6B124AF8FF76040F9598DDC9DE0DA44EF34BBB01B53E2B4713D2D701A9F913BE56F9F5B9B7D8D2006CA910D8BFA0C34C619AB0EEBDAA474E67115532511686992E88C4E32E86D82736B2FE141E9037381757ED02C7D82CA8FC9245700040D7E1E200029416295D891D388D69AC5197A65121B60D42040393FB42BC2769B1E2F649A7A17083F6AB2B1BE6E993';
  if (!await linkv.init(appID, appSecret)) {
    print('await linkv.init');
    return;
  }
  // 初始化 live对象
  var live = linkv.newLvLIVE();

  var thirdUID = 'test-dart-tob';
  var aID = 'test';
  // 进行帐号绑定
  var r = await live.GetTokenByThirdUID(thirdUID, aID,
      userName: 'test-dart',
      portraitURI:
          'http://meet.linkv.sg/app/rank-list/static/img/defaultavatar.cd935fdb.png');

  if (!r['status']) {
    print('await live.GetTokenByThirdUID');
    return;
  }
  print('token:${r['liveToken']}');
  var openID = r['liveOpenID'];
  // 获取金币余额
  var r0 = await live.GetGoldByLiveOpenID(openID);
  if (!r0['status']) {
    print('await live.GetGoldByLiveOpenID');
    return;
  }
  var golds0 = r0['golds'];
  print('golds0:${golds0}');

  // 完成订单
  var orderID = '';
  var gold = 10;
  var r1 = await live.SuccessOrderByLiveOpenID(
      openID, linkv.OrderTypeAdd, gold, 10, 1, linkv.PlatformTypeH5, orderID);
  if (!r1['status']) {
    print('await live.SuccessOrderByLiveOpenID');
    return;
  }
  var golds1 = r1['golds'];
  print('golds1:${golds1}');
  if ((golds0 + gold) != golds1) {
    return;
  }

  // 修改金币
  var r2 =
      await live.ChangeGoldByLiveOpenID(openID, linkv.OrderTypeDel, gold, 1);
  if (!r2['status']) {
    print('await live.ChangeGoldByLiveOpenID');
    return;
  }

  // 获取金币余额
  var r3 = await live.GetGoldByLiveOpenID(openID);
  if (!r3['status']) {
    print('await live.GetGoldByLiveOpenID');
    return;
  }
  var golds2 = r3['golds'];
  print('golds2:${golds2}');
  if (golds0 != golds2) {
    return;
  }
  print('success');
}
```

## License

This SDK is distributed under the
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0),
see LICENSE.txt and NOTICE.txt for more information.