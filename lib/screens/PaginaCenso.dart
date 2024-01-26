import 'package:fancy_containers/fancy_containers.dart';
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
  int selectedCensoId = 1;
  String selectedEstadisticaType = 'total';

  bool mostrarPorcentaje = false;

  bool mostrarPorcentaje1 = false;

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
      body: SingleChildScrollView(
        child: FutureBuilder(
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

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue,
                          Color.fromARGB(255, 2, 138, 250),
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
                                        Radio(
                                          activeColor: Colors.white,
                                          fillColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) => Colors.white),
                                          value: option,
                                          groupValue: selectedEstadisticaType,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedEstadisticaType =
                                                  value as String;
                                            });
                                          },
                                        ),
                                        Text(
                                          option == 'total'
                                              ? 'Total'
                                              : 'por UV',
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
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Seleccionar la Unidad Vencinal',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.timeline,
                                        color: Colors
                                            .white), // Icono decorativo en blanco
                                    SizedBox(width: 8),
                                    DropdownButton<int>(
                                      dropdownColor: const Color.fromARGB(
                                          255, 3, 126, 226),
                                      value: selectedCensoId,
                                      items: estadisticasFiltradas
                                          .map<DropdownMenuItem<int>>((censo) {
                                        return DropdownMenuItem<int>(
                                          value: censo['id'] as int,
                                          child: Text('UV: ${censo['uv']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .white)), // Texto negro
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCensoId = value!;
                                        });
                                      },
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Mostrar detalles del censo seleccionado
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                FancyContainer(
                                  height: 80,
                                  width: double.infinity,
                                  title: selectedEstadisticaType == 'total'
                                      ? 'Porcentaje de Personas'
                                      : 'Total de Personas',
                                  titleStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: selectedEstadisticaType == 'total'
                                      ? 'Porcentaje :  (${((estadisticasFiltradas[selectedCensoId - 1]['total_pers'] ?? 0).toInt() / totalPoblacionValparaiso * 100).toStringAsFixed(2)}%)'
                                      : 'por UV: ${estadisticasFiltradas[selectedCensoId - 1]['total_pers'] ?? 'N/A'} personas',
                                  color1: Color.fromARGB(255, 0, 183, 255),
                                  color2: Colors.blue,
                                  textColor: Colors.white,
                                  subtitleColor: Colors.white,
                                ),

                                // ... Agrega el resto de los datos según tus necesidades
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FancyContainer(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 2.1,
                              title: 'Total de Hombres',
                              color1: Color.fromARGB(255, 0, 183, 255),
                              color2: Colors.blue,
                              textColor: Colors.white,
                              subtitleColor: Colors.white,
                              subtitle: mostrarPorcentaje
                                  ? '${((estadisticasFiltradas[selectedCensoId - 1]['hombres'] as int) / (estadisticasFiltradas[selectedCensoId - 1]['total_pers'] as int) * 100).toStringAsFixed(2)}%'
                                  : '${estadisticasFiltradas[selectedCensoId - 1]['hombres']} hombres',
                              onTap: () {
                                setState(() {
                                  mostrarPorcentaje = !mostrarPorcentaje;
                                });
                              },
                            ),
                            FancyContainer(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 2.1,
                              title: 'Total de mujeres',
                              color1: Color.fromARGB(255, 0, 183, 255),
                              color2: Colors.blue,
                              textColor: Colors.white,
                              subtitleColor: Colors.white,
                              subtitle: mostrarPorcentaje1
                                  ? '${((estadisticasFiltradas[selectedCensoId - 1]['mujeres'] as int) / (estadisticasFiltradas[selectedCensoId - 1]['total_pers'] as int) * 100).toStringAsFixed(2)}%'
                                  : '${estadisticasFiltradas[selectedCensoId - 1]['mujeres']} mujeres',
                              onTap: () {
                                setState(() {
                                  mostrarPorcentaje1 = !mostrarPorcentaje1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
