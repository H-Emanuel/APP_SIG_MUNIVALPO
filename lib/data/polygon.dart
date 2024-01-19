import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proj4dart/proj4dart.dart' as proj4;

Future<List<LatLng>> fetchPolygon() async {
  try {
    final response =
        await http.get(Uri.parse('https://apisig.munivalpo.cl/api/limite'));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      final String wktGeometry = data[0]['geom'];
      final List<String> coordinates = wktGeometry
          .replaceAll('MULTIPOLYGON (((', '')
          .replaceAll(')))', '')
          .split(',');

      final proj4.Projection? customProjection = proj4.Projection.add(
        'EPSG:32719',
        '+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs',
      );

      final proj4.Projection? toProjection = proj4.Projection.get('EPSG:4326');

      if (customProjection != null && toProjection != null) {
        final List<LatLng> points = coordinates.map((coord) {
          final List<String> parts = coord.trim().split(' ');
          final double x = double.parse(parts[0]);
          final double y = double.parse(parts[1]);
          final proj4.Point point = proj4.Point(x: x, y: y);
          final proj4.Point? transformedPoint =
              customProjection.transform(toProjection, point);
          if (transformedPoint != null) {
            return LatLng(transformedPoint.y, transformedPoint.x);
          } else {
            throw Exception('Error en la transformación de coordenadas');
          }
        }).toList();
        return points;
      } else {
        throw Exception(
            'Error al definir la proyección personalizada EPSG:32719');
      }
    } else {
      throw Exception('Error al cargar datos del polígono desde la API');
    }
  } catch (e) {
    throw e;
  }
}
