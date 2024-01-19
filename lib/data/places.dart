import 'dart:convert';
import 'package:http/http.dart' as http;

class Place {
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  Place({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

Future<List<Place>> fetchPlaces() async {
  final response = await http
      .get(Uri.parse('https://apisig.munivalpo.cl/api/equipamientos/'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final List<Place> fetchedPlaces = data.map((item) {
      return Place(
        name: item['nombre'],
        description: item['tipologia'],
        latitude: item['y_coord'],
        longitude: item['x_coord'],
      );
    }).toList();
    return fetchedPlaces;
  } else {
    throw Exception('Error al cargar datos desde la API');
  }
}
