class rtcConfig {
  final String apiID;
  final String apiKey;

  rtcConfig._(this.apiID, this.apiKey);

  factory rtcConfig.fromJson(Map<String, dynamic> json) {
    var apiID = json['api_id'] ?? '';
    var apiKey = json['api_key'] ?? '';
    return rtcConfig._(apiID, apiKey);
  }
}
