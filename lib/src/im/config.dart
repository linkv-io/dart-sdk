class imConfig {
  final String appID;
  final String appKey;
  final String appSecret;
  final String url;

  imConfig._(this.appID, this.appKey, this.appSecret, this.url);

  factory imConfig.fromJson(Map<String, dynamic> json) {
    var appID = json['app_id'] ?? '';
    var appKey = json['app_key'] ?? '';
    var appSecret = json['app_secret'] ?? '';
    var url = json['url'] ?? '';
    return imConfig._(appID, appKey, appSecret, url);
  }
}
