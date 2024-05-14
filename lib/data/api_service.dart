// api_service.dart

import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchEquipamientos() async {
    final response = await http.get(Uri.parse('$baseUrl/equipamientos/'));

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> equipamientos =
          json.decode(response.body).cast<Map<String, dynamic>>();

      // Filtrar los equipamientos activos
      final List<Map<String, dynamic>> equipamientosActivos = equipamientos
          .where((equipamiento) => equipamiento['is_active'] == true)
          .toList();

      return equipamientosActivos;
    } else {
      throw Exception('Error al cargar los equipamientos');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCensoData() async {
    final response = await http.get(Uri.parse('$baseUrl/censo/'));

    if (response.statusCode == 200) {
      // Decodificar la respuesta usando UTF-8
      var utf8Json = utf8.decode(response.bodyBytes);
      return json.decode(utf8Json).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los datos del censo');
    }
  }
}
