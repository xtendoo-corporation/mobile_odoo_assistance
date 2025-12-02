import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/app_config.dart';

class OdooService {
  final AppConfig config;

  OdooService(this.config);

  // Método agregado para probar la conexión
  Future<bool> probarConexion() async {
    try {
      final url = Uri.parse('${config.odooUrl}/web/database/selector');
      final response = await http.get(url).timeout(
        Duration(seconds: 10),
      );


      return response.statusCode == 200 || response.statusCode == 404 || response.statusCode == 303;
    } catch (e) {
      print('Error en conexión: $e');
      return false;
    }
  }

  Future<bool> _probarConexionXmlRpc() async {

    try {
      // TODO Aquí iría la implementación real con odoo_rpc
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
