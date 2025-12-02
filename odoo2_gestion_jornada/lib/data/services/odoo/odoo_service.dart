import '../../../config/odoo_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooService {
  Future<Map<String, dynamic>?> buscarEmpleadoPorTelefono(String telefono) async {
    final telefonoLimpio = telefono.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Implementación real usando XML-RPC recomendado
    return await _buscar([
      ['mobile_phone', 'ilike', telefonoLimpio]
    ]);
  }

  Future<Map<String, dynamic>?> _buscar(List domain) async {
    // TODO: implementar XML-RPC real con paquete odoo_rpc

    return null; // temporal
  }
}
