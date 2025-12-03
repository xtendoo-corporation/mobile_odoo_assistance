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


    final payload = '$telefono|$baseUrl|$pin|$accion|${posicion.latitude},${posicion.longitude}';

    final encoded = Uri.encodeComponent(payload);

    final uri = Uri.parse('$baseUrl?data=$encoded');

    final resp = await http.get(uri).timeout(const Duration(seconds: 10));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {

      return;
    } else {
      throw Exception('Error HTTP: ${resp.statusCode} - ${resp.body}');
    }
  }
}
