import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> enviarMarcaje({
    required String baseUrl,
    required String telefono,
    required String pin,
    required bool entrando,
    required Position posicion,
  }) async {
    final accion = entrando ? 'entrando' : 'saliendo';

    final Map<String, dynamic> body = {
      'telefono': telefono,
      'pin': pin,
      'accion': accion,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
    };

    final uri = Uri.parse(baseUrl);

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      // Parsear la respuesta JSON
      final responseData = jsonDecode(resp.body);

      // Verificar el status en la respuesta
      if (responseData['status'] == 'success') {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Error desconocido del servidor');
      }
    } else {
      throw Exception('Error HTTP: ${resp.statusCode} - ${resp.body}');
    }
  }
}
