import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class ApiService {

  Future<void> enviarMarcaje({
    required String baseUrl,
    required String telefono,
    required String pin,
    required bool entrando,
    required Position posicion,
  }) async {
    final accion = entrando ? 'entrando' : 'saliendo';

    // Preparar el body como JSON
    final Map<String, dynamic> body = {
      'telefono': telefono,
      'pin': pin,
      'accion': accion,
      'latitud': posicion.latitude,
      'longitud': posicion.longitude,
    };

    // Hacer la petición POST con tipo JSON
    final uri = Uri.parse(baseUrl);

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      //print('Respuesta del servidor: ${resp.body}');
      return;
    } else {
      throw Exception('Error HTTP: ${resp.statusCode} - ${resp.body}');
    }
  }
}
