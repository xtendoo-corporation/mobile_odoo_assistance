// 2. SERVICIO DE CONFIGURACIÓN (Almacenamiento Seguro)
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../models/app_config.dart';

class ConfigService {
  final storage = FlutterSecureStorage();
  static const String CONFIG_KEY = 'app_config';

  Future<void> guardarConfiguracion(AppConfig config) async {
    await storage.write(
      key: CONFIG_KEY,
      value: jsonEncode(config.toJson()),
    );
  }

  Future<AppConfig?> obtenerConfiguracion() async {
    final configJson = await storage.read(key: CONFIG_KEY);
    if (configJson != null) {
      return AppConfig.fromJson(jsonDecode(configJson));
    }
    return null;
  }

  Future<bool> estaConfigurado() async {
    final config = await obtenerConfiguracion();
    return config != null &&
        config.odooUrl.isNotEmpty &&
        config.numeroTelefono.isNotEmpty;
  }

  Future<void> limpiarConfiguracion() async {
    await storage.delete(key: CONFIG_KEY);
  }
}
