import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'app_config.dart';

class ConfigService {
  final storage = const FlutterSecureStorage();
  static const String CONFIG_KEY = 'app_config';

  Future<void> guardarConfiguracion(AppConfig config) async {
    await storage.write(
      key: CONFIG_KEY,
      value: jsonEncode(config.toJson()),
    );
  }

  Future<AppConfig?> obtenerConfiguracion() async {
    final data = await storage.read(key: CONFIG_KEY);
    if (data != null) {
      return AppConfig.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<bool> estaConfigurado() async {
    final config = await obtenerConfiguracion();
    return config != null &&
        config.numeroTelefono.isNotEmpty &&
        config.empleadoId != null;
  }

  Future<void> limpiar() async => await storage.delete(key: CONFIG_KEY);
}
