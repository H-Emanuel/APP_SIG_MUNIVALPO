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
  int selectedCensoId = 1; // Valor predeterminado
  String selectedEstadisticaType = 'general';

  @override
  void initState() {
    super.initState();
    censoData = _apiService.fetchCensoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: Text(
          'Datos del Censo',
          style: TextStyle(color: Colors.white),
        ),
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

            // Calcular el total de personas de todas las UV
            int totalPoblacionValparaiso = 0;
            censos.forEach((censo) {
              totalPoblacionValparaiso += (censo['total_pers'] ?? 0) as int;
            });

            // Filtrar datos según el tipo de estadística seleccionado
            List<Map<String, dynamic>> estadisticasFiltradas = [];
            if (selectedEstadisticaType == 'general') {
              estadisticasFiltradas = censos;
            } else {
              estadisticasFiltradas =
                  censos.where((censo) => censo['uv'] != null).toList();
            }

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue,
                    const Color.fromARGB(255, 67, 170, 255),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar el total de personas de todas las UV
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total de Personas en Valparaíso: $totalPoblacionValparaiso',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),

                  // RadioButtons para seleccionar el tipo de estadística
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comparar estadísticas:',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            for (final option in ['total', 'uv'])
                              Row(
                                children: [
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: Colors.white),
                                    child: Radio(
                                      activeColor: Colors.white,
                                      focusColor: Colors.white,
                                      hoverColor: Colors.white,
                                      value: option,
                                      groupValue: selectedEstadisticaType,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedEstadisticaType =
                                              value as String;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    option == 'total' ? 'Total' : 'por UV',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Dropdown para seleccionar la ID del censo
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<int>(
                      value: selectedCensoId,
                      items: estadisticasFiltradas
                          .map<DropdownMenuItem<int>>((censo) {
                        return DropdownMenuItem<int>(
                          value: censo['id'] as int,
                          child: Text('ID: ${censo['id']}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCensoId = value!;
                        });
                      },
                    ),
                  ),

                  // Mostrar detalles del censo seleccionado
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${selectedCensoId}'),
                          SizedBox(height: 8),
                          Text(
                              'Unidad Vecinal: ${estadisticasFiltradas[selectedCensoId - 1]['uv'] ?? 'N/A'}'),
                          SizedBox(height: 8),
                          Text(
                              'Total de Personas: ${estadisticasFiltradas[selectedCensoId - 1]['total_pers'] ?? 'N/A'}'),
                          // ... Agrega el resto de los datos según tus necesidades
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
