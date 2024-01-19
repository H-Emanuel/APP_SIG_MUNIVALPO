import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'places.dart';
import 'polygon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Place> places = [];
  List<LatLng> polygonPoints = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    try {
      final List<Place> fetchedPlaces = await fetchPlaces();

      final List<LatLng> fetchedPolygon = await fetchPolygon();
      setState(() {
        places = fetchedPlaces;
        polygonPoints = fetchedPolygon;
      });
    } catch (e) {
      // Manejar errores aquí
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-33.0520342, -71.6038088),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          // Manejar POLIGONOS AQUI aquí
          PolygonLayer(
            polygons: [
              Polygon(
                points: polygonPoints,
                color: Color.fromARGB(195, 0, 204, 255),
                borderColor: Color.fromARGB(255, 255, 255, 255),
                borderStrokeWidth: 1,
                isFilled: true,
              ),
            ],
          ),
          // DragMarkers(
          //     markers: places
          //         .map((place) => DragMarker(
          //               point: LatLng(place.latitude, place.longitude),
          //               builder: (_, __, ___) => const Icon(
          //                 Icons.location_on,
          //                 size: 50,
          //                 color: Colors.blueGrey,
          //               ),
          //               size: const Size.square(50),
          //             ))
          //         .toList()),

          MarkerLayer(
            markers: places
                .map((place) => Marker(
                    width: 700.0,
                    height: 700.0,
                    point: LatLng(place.latitude, place.longitude),
                    child: Container(
                        child: Icon(
                      Icons.location_on,
                      color: Color.fromARGB(255, 151, 131, 130),
                      size: 30.0,
                    ))))
                .toList(),
          ),
        ],
      ),
    );
  }
}
