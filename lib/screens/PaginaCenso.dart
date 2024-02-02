import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '/data/api_service.dart';

class PaginaCenso extends StatefulWidget {
  @override
  _PaginaCensoState createState() => _PaginaCensoState();
}

class EdadesData {
  final String edad;
  final int total;

  EdadesData(this.edad, this.total);
}

class GeneroData {
  final String genero;
  final int total;

  GeneroData(this.genero, this.total);
}

class _PaginaCensoState extends State<PaginaCenso> {
  final ApiService _apiService =
      ApiService(baseUrl: 'https://apisig.munivalpo.cl/api');
  late Future<List<Map<String, dynamic>>> censoData;
  int selectedCensoId = 1;
  String selectedEstadisticaType = 'total';

  bool mostrarPorcentaje = false;

  bool mostrarPorcentaje1 = false;

  bool mostrarPorcentaje3 = false;

  bool mostrarPorcentaje4 = false;

  bool mostrarPorcentaje5 = false;

  bool mostrarPorcentaje6 = false;

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
              final List<EdadesData> edadesData = [
                EdadesData(
                    '0-5',
                    estadisticasFiltradas[selectedCensoId - 1]['edad_0a5']
                        as int),
                EdadesData(
                    '6-14',
                    estadisticasFiltradas[selectedCensoId - 1]['edad_6a14']
                        as int),
                EdadesData(
                    '15-64',
                    estadisticasFiltradas[selectedCensoId - 1]['edad_15a64']
                        as int),
                EdadesData(
                    '65+',
                    estadisticasFiltradas[selectedCensoId - 1]['edad_65yma']
                        as int),
              ];

              int hombres =
                  estadisticasFiltradas[selectedCensoId - 1]['hombres'] as int;
              int mujeres =
                  estadisticasFiltradas[selectedCensoId - 1]['mujeres'] as int;

              List<GeneroData> generoData = [
                GeneroData('Hombres', hombres),
                GeneroData('Mujeres', mujeres),
              ];

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
                          decoration: BoxDecoration(
                            boxShadow: null, // o boxShadow: null
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                FancyContainer(
                                  height: 70,
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
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 400,
                          height: 350,
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              PieSeries<GeneroData, String>(
                                dataSource: generoData,
                                xValueMapper: (GeneroData data, _) =>
                                    data.genero,
                                yValueMapper: (GeneroData data, _) =>
                                    data.total,
                                pointColorMapper: (GeneroData data, _) {
                                  return generoData.indexOf(data) % 2 == 0
                                      ? Color.fromARGB(255, 2, 124, 224)
                                      : Color.fromARGB(255, 255, 138, 109);
                                },
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            legend: Legend(
                              textStyle: TextStyle(color: Colors.white),
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarPorcentaje = !mostrarPorcentaje;
                                });
                              },
                              child: NContainer(
                                  context,
                                  estadisticasFiltradas,
                                  'Total de Hombres',
                                  'hombres',
                                  mostrarPorcentaje,
                                  170),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarPorcentaje1 = !mostrarPorcentaje1;
                                });
                              },
                              child: NContainer(
                                  context,
                                  estadisticasFiltradas,
                                  'Total de Mujeres',
                                  'mujeres',
                                  mostrarPorcentaje1,
                                  170),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        Container(
                          width: 650,
                          height: 500, // Altura del gráfico
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            series: <BarSeries>[
                              BarSeries<EdadesData, String>(
                                color: Colors
                                    .white, // Cambia el color de las barras a blanco
                                trackColor: Colors.white,
                                dataSource: edadesData,

                                xValueMapper: (EdadesData data, _) => data.edad,
                                yValueMapper: (EdadesData data, _) =>
                                    data.total,

                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors
                                          .white), // Cambia el color del texto de las etiquetas en las barras
                                ),
                              ),
                            ],
                            legend: Legend(
                              textStyle: TextStyle(color: Colors.white),
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje3 = !mostrarPorcentaje3;
                                    });
                                  },
                                  child: NContainer(
                                      context,
                                      estadisticasFiltradas,
                                      'Edad 0-5',
                                      'edad_0a5',
                                      mostrarPorcentaje3,
                                      150),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje4 = !mostrarPorcentaje4;
                                    });
                                  },
                                  child: NContainer(
                                      context,
                                      estadisticasFiltradas,
                                      'Edad 6-14',
                                      'edad_6a14',
                                      mostrarPorcentaje4,
                                      150),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje5 = !mostrarPorcentaje5;
                                    });
                                  },
                                  child: NContainer(
                                      context,
                                      estadisticasFiltradas,
                                      'Edad 15-64',
                                      'edad_15a64',
                                      mostrarPorcentaje5,
                                      150),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje6 = !mostrarPorcentaje6;
                                    });
                                  },
                                  child: NContainer(
                                      context,
                                      estadisticasFiltradas,
                                      'Edad 65 y mas',
                                      'edad_65yma',
                                      mostrarPorcentaje6,
                                      150),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
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

  Container NContainer(
    BuildContext context,
    List<Map<String, dynamic>> estadisticasFiltradas,
    String titulo,
    String dato,
    bool mostrar,
    double ancho,
  ) {
    return Container(
      width: ancho,
      height: MediaQuery.of(context).size.width / 3,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    offset: const Offset(0, 20),
                    blurRadius: 30,
                    spreadRadius: -20),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 86, 193, 255),
                  Color.fromARGB(255, 28, 172, 255),
                  Color.fromARGB(255, 0, 148, 233),
                  Color.fromARGB(255, 2, 141, 221),
                ],
                stops: const [0.1, 0.3, 0.9, 1.0],
              ),
            ),
          ),
          // Texto
          Positioned(
            bottom: 35,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    mostrar
                        ? '${((estadisticasFiltradas[selectedCensoId - 1][dato] as int) / (estadisticasFiltradas[selectedCensoId - 1]['total_pers'] as int) * 100).toStringAsFixed(2)}%'
                        : '${estadisticasFiltradas[selectedCensoId - 1][dato]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
