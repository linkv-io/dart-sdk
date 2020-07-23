class imConfig {
  final String appName;
  final String apiID;
  final String apiKey;
  final String apiURI;

  imConfig._(this.appName, this.apiID, this.apiKey, this.apiURI);

  factory imConfig.fromJson(Map<String, dynamic> json) {
    var appName = json['app_name'] ?? '';
    var apiID = json['api_id'] ?? '';
    var apiKey = json['api_key'] ?? '';
    var apiURI = json['url'] ?? '';
    return imConfig._(appName, apiID, apiKey, apiURI);
  }
}
