class SmtpConfig {
  String key;
  String value;

  SmtpConfig({
    required this.key,
    required this.value,
  });

  factory SmtpConfig.fromJson(Map<String, dynamic> json) => SmtpConfig(
    key: json["key"],
    value: json["value"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}
