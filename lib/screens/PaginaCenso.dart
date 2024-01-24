import 'package:flutter/material.dart';
import '/data/api_service.dart';

class PaginaCenso extends StatefulWidget {
  @override
  _PaginaCensoState createState() => _PaginaCensoState();
}

class _PaginaCensoState extends State<PaginaCenso> {
  final ApiService _apiService =
      ApiService(baseUrl: 'https://apisig.munivalpo.cl/api');
  late Future<List<Map<String, dynamic>>> censoData;

  @override
  void initState() {
    super.initState();
    censoData = _apiService.fetchCensoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos del Censo'),
      ),
      body: FutureBuilder(
        future: censoData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> censos =
                snapshot.data as List<Map<String, dynamic>>;

            if (censos.isEmpty) {
              return Center(child: Text('No se encontraron datos de censo.'));
            }

            return ListView.builder(
              itemCount: censos.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> censo = censos[index];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${censo['id']}'),
                      SizedBox(height: 8),
                      Text('Unidad Vecinal: ${censo['uv']}'),
                      SizedBox(height: 8),
                      Text('Total de Personas: ${censo['total_pers']}'),
                      // ... Agrega el resto de los datos según tus necesidades
                      Divider(), // Separador entre conjuntos de datos
                      SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
