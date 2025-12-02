import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../config/odoo_constants.dart';

class OdooService {

  Future<bool> probarConexion() async {
    try {
      if (OdooConstants.USAR_API_REST) {
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
    final response = await http.post(
      Uri.parse('${OdooConstants.ODOO_URL}/api/auth/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'db': OdooConstants.ODOO_DATABASE,
        'login': OdooConstants.ODOO_USERNAME,
        'password': OdooConstants.ODOO_PASSWORD,
      }),
    ).timeout(Duration(seconds: 10));

    return response.statusCode == 200;
  }

  Future<bool> _probarConexionXmlRpc() async {
    // Implementación con odoo_rpc package
    // Por ahora retornamos true para ejemplo
    return true;
  }

  Future<Map<String, dynamic>?> buscarEmpleadoPorTelefono(String telefono) async {
    try {
      // Normalizar el teléfono (eliminar espacios, guiones, etc.)
      final telefonoLimpio = telefono.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      // Buscar por mobile_phone
      var empleados = await _buscarEmpleados([
        ['mobile_phone', 'ilike', telefonoLimpio]
      ]);

      if (empleados.isNotEmpty) {
        return empleados.first;
      }

      // Si no se encuentra, buscar por work_phone
      empleados = await _buscarEmpleados([
        ['work_phone', 'ilike', telefonoLimpio]
      ]);

      if (empleados.isNotEmpty) {
        return empleados.first;
      }

      // Última búsqueda: sin espacios ni caracteres especiales
      empleados = await _buscarEmpleados([
        '|',
        ['mobile_phone', 'ilike', telefono],
        ['work_phone', 'ilike', telefono]
      ]);

      return empleados.isNotEmpty ? empleados.first : null;
    } catch (e) {
      print('Error buscando empleado: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _buscarEmpleados(List domain) async {
    // IMPLEMENTACIÓN CON XML-RPC (Recomendado)
    // Necesitarás el paquete odoo_rpc

    /* EJEMPLO CON odoo_rpc:

    final client = OdooClient(OdooConstants.ODOO_URL);
    await client.authenticate(
      OdooConstants.ODOO_DATABASE,
      OdooConstants.ODOO_USERNAME,
      OdooConstants.ODOO_PASSWORD,
    );

    final empleados = await client.callKw({
      'model': 'hr.employee',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'domain': domain,
        'fields': ['id', 'name', 'mobile_phone', 'work_phone', 'work_email'],
        'limit': 1,
      },
    });

    return List<Map<String, dynamic>>.from(empleados);
    */

    // Por ahora retorno de ejemplo para que compile
    return [];
  }

  Future<bool> registrarEntrada(int empleadoId) async {
    // Registrar entrada de jornada
    try {
      // Implementar llamada a Odoo para crear registro de asistencia
      return true;
    } catch (e) {
      print('Error registrando entrada: $e');
      return false;
    }
  }

  Future<bool> registrarSalida(int empleadoId) async {
    // Registrar salida de jornada
    try {
      // Implementar llamada a Odoo para actualizar registro de asistencia
      return true;
    } catch (e) {
      print('Error registrando salida: $e');
      return false;
    }
  }
}