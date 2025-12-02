// 4. SERVICIO ODOO CON CONFIGURACIÓN
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/app_config.dart';

class OdooService {
  final AppConfig config;

  OdooService(this.config);

  Future<bool> probarConexion() async {
    try {
      if (config.usarApiRest) {
        return await _probarConexionRest();
      } else {
        return await _probarConexionXmlRpc();
      }
    } catch (e) {
      print('Error probando conexión: $e');
      return false;
    }
  }

  Future<bool> _probarConexionRest() async {
    // Implementación REST
    final response = await http.post(
      Uri.parse('${config.odooUrl}/api/auth/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'db': config.odooDatabase,
        'login': config.odooUsername,
        'password': config.odooPassword,
      }),
    ).timeout(Duration(seconds: 10));

    return response.statusCode == 200;
  }

  Future<bool> _probarConexionXmlRpc() async {
    // Implementación XML-RPC usando el paquete odoo_rpc
    // Este es un ejemplo simplificado
    try {
      // Aquí iría la implementación real con odoo_rpc
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> buscarEmpleadoPorTelefono() async {
    try {
      // Buscar empleado que coincida con el número configurado
      final empleados = await _buscarEmpleados([
        ['mobile_phone', '=', config.numeroTelefono]
      ]);

      if (empleados.isNotEmpty) {
        return empleados.first;
      }

      // Si no se encuentra por móvil, buscar por teléfono de trabajo
      final empleados2 = await _buscarEmpleados([
        ['work_phone', '=', config.numeroTelefono]
      ]);

      return empleados2.isNotEmpty ? empleados2.first : null;
    } catch (e) {
      print('Error buscando empleado: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _buscarEmpleados(List domain) async {
    // Implementación de búsqueda según API elegida
    // Retorna lista de empleados que cumplen el criterio
    return [];
  }
}