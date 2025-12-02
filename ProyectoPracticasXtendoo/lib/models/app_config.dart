// 1. MODELO DE CONFIGURACIÓN
class AppConfig {
  final String odooUrl;
  final String odooDatabase;
  final String odooUsername;
  final String odooPassword;
  final String numeroTelefono;
  final bool usarApiRest; // true para REST, false para XML-RPC

  AppConfig({
    required this.odooUrl,
    required this.odooDatabase,
    required this.odooUsername,
    required this.odooPassword,
    required this.numeroTelefono,
    this.usarApiRest = false,
  });

  Map<String, dynamic> toJson() => {
    'odooUrl': odooUrl,
    'odooDatabase': odooDatabase,
    'odooUsername': odooUsername,
    'odooPassword': odooPassword,
    'numeroTelefono': numeroTelefono,
    'usarApiRest': usarApiRest,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    odooUrl: json['odooUrl'] ?? '',
    odooDatabase: json['odooDatabase'] ?? '',
    odooUsername: json['odooUsername'] ?? '',
    odooPassword: json['odooPassword'] ?? '',
    numeroTelefono: json['numeroTelefono'] ?? '',
    usarApiRest: json['usarApiRest'] ?? false,
  );
}