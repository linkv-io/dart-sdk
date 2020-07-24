class rtcConfig {
  final String appID;
  final String appKey;

  rtcConfig._(this.appID, this.appKey);

  factory rtcConfig.fromJson(Map<String, dynamic> json) {
    var appID = json['app_id'] ?? '';
    var appKey = json['app_key'] ?? '';
    return rtcConfig._(appID, appKey);
  }
}
