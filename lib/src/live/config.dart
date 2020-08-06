class liveConfig {
  final String appID;
  final String appKey;
  final String appSecret;
  final String url;
  final String alias;

  liveConfig._(this.appID, this.appKey, this.appSecret, this.url, this.alias);

  factory liveConfig.fromJson(Map<String, dynamic> json) {
    var appID = json['app_id'] ?? '';
    var appKey = json['app_key'] ?? '';
    var appSecret = json['app_secret'] ?? '';
    var url = json['url'] ?? '';
    var alias = json['alias'] ?? '';
    return liveConfig._(appID, appKey, appSecret, url, alias);
  }
}
