class AppConfig {
  final String numeroTelefono;
  final int? empleadoId; // ID del empleado en Odoo (se obtiene automáticamente)
  final String? nombreEmpleado;

  AppConfig({
    required this.numeroTelefono,
    this.empleadoId,
    this.nombreEmpleado,
  });

  Map<String, dynamic> toJson() => {
    'numeroTelefono': numeroTelefono,
    'empleadoId': empleadoId,
    'nombreEmpleado': nombreEmpleado,
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    numeroTelefono: json['numeroTelefono'] ?? '',
    empleadoId: json['empleadoId'],
    nombreEmpleado: json['nombreEmpleado'],
  );
}