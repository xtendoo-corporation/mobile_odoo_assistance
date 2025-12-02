class AppConfig {
  final String odooUrl;
  final String numeroTelefono;

  AppConfig({
    required this.odooUrl,
    required this.numeroTelefono,
  });

  Map<String, dynamic> toJson() => {
    'odooUrl': odooUrl,
    'numeroTelefono': numeroTelefono,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    odooUrl: json['odooUrl'] ?? '',
    numeroTelefono: json['numeroTelefono'] ?? '',
  );
}