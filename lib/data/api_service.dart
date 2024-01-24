// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchEquipamientos() async {
    final response = await http.get(Uri.parse('$baseUrl/equipamientos/'));

    if (response.statusCode == 200) {
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los equipamientos');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCensoData() async {
    final response = await http.get(Uri.parse('$baseUrl/censo/'));

    if (response.statusCode == 200) {
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los datos del censo');
    }
  }
}
