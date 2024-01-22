import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://apisig.munivalpo.cl/api/equipamientos/';

  Future<List<Map<String, dynamic>>> fetchEquipamientos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los equipamientos');
    }
  }
}
