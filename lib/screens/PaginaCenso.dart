import 'package:fancy_containers/fancy_containers.dart';
import 'package:flutter/material.dart';
import 'package:mapa_sig_1/resources/mi_colores.dart';
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

  String selectedCerro = 'Placilla';

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
        centerTitle: true,
        foregroundColor: AppColors.texto_1,
        backgroundColor: AppColors.fondo,
        title: Text(
          'Demografia',
          style: TextStyle(
            color: AppColors.texto_1,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
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

              int totalHombresValparaiso = 0;
              int totalMujeresValparaiso = 0;
              int totalPoblacionValparaiso = 0;
              int totalEdad0_5 = 0;
              int totalEdad6_14 = 0;
              int totalEdad15_64 = 0;
              int totalEdad65 = 0;

              censos.forEach((censo) {
                totalPoblacionValparaiso += (censo['total_pers'] ?? 0) as int;
                totalHombresValparaiso += (censo['hombres'] ?? 0) as int;
                totalMujeresValparaiso += (censo['mujeres'] ?? 0) as int;

                totalEdad0_5 += (censo['edad_0a5'] ?? 0) as int;
                totalEdad6_14 += (censo['edad_6a14'] ?? 0) as int;
                totalEdad15_64 += (censo['edad_15a64'] ?? 0) as int;
                totalEdad65 += (censo['edad_65yma'] ?? 0) as int;
              });

              List<GeneroData> DataTotal = [
                GeneroData('Hombres', totalHombresValparaiso),
                GeneroData('Mujeres', totalMujeresValparaiso),
              ];

              List<GeneroData> DataTotal_edades = [
                GeneroData('Edad 0 a 5', totalEdad0_5),
                GeneroData('Edad 6 a 14', totalEdad6_14),
                GeneroData('Edad 15 a 64', totalEdad15_64),
                GeneroData('Edad 65 y mas', totalEdad65),
              ];

              Map<String, dynamic> datosAgrupados = {};
              censos.forEach((censo) {
                String cerro = censo['cerro'] as String;
                String uv = censo['uv']
                    as String; // Asegurarse de que 'uv' sea una cadena

                if (!datosAgrupados.containsKey(cerro)) {
                  datosAgrupados[cerro] = {
                    'edad_0a5': 0,
                    'edad_6a14': 0,
                    'edad_15a64': 0,
                    'edad_65yma': 0,
                    'total_pers': 0,
                    'hombres': 0,
                    'mujeres': 0,
                    'uvs': <String>[], // Inicializar una lista vacía de 'uv'
                  };
                }

                // Sumar los valores correspondientes a cada rango de edad
                datosAgrupados[cerro]['edad_0a5'] += censo['edad_0a5'] as int;
                datosAgrupados[cerro]['edad_6a14'] += censo['edad_6a14'] as int;
                datosAgrupados[cerro]['edad_15a64'] +=
                    censo['edad_15a64'] as int;
                datosAgrupados[cerro]['edad_65yma'] +=
                    censo['edad_65yma'] as int;

                // Sumar los valores de hombres y mujeres
                datosAgrupados[cerro]['hombres'] += censo['hombres'] as int;
                datosAgrupados[cerro]['mujeres'] += censo['mujeres'] as int;
                datosAgrupados[cerro]['total_pers'] +=
                    censo['total_pers'] as int;

                // Agregar la 'uv' a la lista si no está ya presente
                if (!datosAgrupados[cerro]['uvs'].contains(uv)) {
                  datosAgrupados[cerro]['uvs'].add(uv);
                }
              });

              List<EdadesData> edadesAgrupado = [];
              List<GeneroData> agrupadosData = [];

              edadesAgrupado = [
                EdadesData('Edad 0 a 5',
                    datosAgrupados[selectedCerro]!['edad_0a5'] as int),
                EdadesData('Edad 6 a 14',
                    datosAgrupados[selectedCerro]!['edad_6a14'] as int),
                EdadesData('Edad 15 a 64',
                    datosAgrupados[selectedCerro]!['edad_15a64'] as int),
                EdadesData('Edad 65 y mas',
                    datosAgrupados[selectedCerro]!['edad_65yma'] as int),
              ];

              agrupadosData = [
                GeneroData('Hombres',
                    datosAgrupados[selectedCerro]!['hombres'] as int),
                GeneroData('Mujeres',
                    datosAgrupados[selectedCerro]!['mujeres'] as int),
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
                          Color.fromARGB(255, 20, 4, 242),
                          Color.fromARGB(255, 20, 4, 242),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: const [
                                Text(
                                  'Datos del Censo 2017',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        8), // Separación entre el texto y la línea
                                Divider(
                                  color: Color.fromARGB(
                                      255, 255, 255, 255), // Color de la línea
                                  thickness: 2, // Grosor de la línea
                                ),
                              ],
                            ),
                          ),
                        ),

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
                                  for (final option in ['total', 'general'])
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
                                              : 'por Cerros',
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
                                  'Seleccione su Cerro',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.timeline, color: Colors.white),
                                    SizedBox(width: 8),
                                    DropdownButton<String>(
                                      dropdownColor: AppColors.cuadro_1,
                                      value: selectedCerro,
                                      items: datosAgrupados.keys
                                          .map<DropdownMenuItem<String>>(
                                              (cerro) {
                                        return DropdownMenuItem<String>(
                                          value: cerro,
                                          child: Text(
                                            'Cerro: $cerro ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: selectedEstadisticaType ==
                                                      'general'
                                                  ? AppColors.texto_1
                                                  : AppColors.texto_2,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged:
                                          selectedEstadisticaType == 'general'
                                              ? (value) {
                                                  setState(() {
                                                    selectedCerro = value!;
                                                  });
                                                }
                                              : null,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
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
                                  height: 120,
                                  width: double.infinity,
                                  title: selectedEstadisticaType == 'total'
                                      ? 'Cerros Totales'
                                      : 'UV en los Cerro: $selectedCerro',
                                  titleStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: selectedEstadisticaType == 'total'
                                      ? 'Totales: ${datosAgrupados.length} Cerros' // Cambio aquí
                                      : 'UV asociado: ${datosAgrupados[selectedCerro]['uvs'].join(', ')}', // Cambio aquí
                                  color1: Color.fromARGB(255, 22, 17, 167),
                                  color2: Color.fromARGB(255, 10, 0, 149),
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
                                dataSource: selectedEstadisticaType == 'total'
                                    ? DataTotal
                                    : agrupadosData,
                                xValueMapper: (GeneroData data, _) =>
                                    data.genero,
                                yValueMapper: (GeneroData data, _) =>
                                    data.total,
                                pointColorMapper: (GeneroData data, _) {
                                  // Asignar colores basados en el género
                                  return data.genero == 'Mujeres'
                                      ? Color.fromARGB(255, 0, 157, 254)
                                      : Color.fromARGB(255, 52, 167, 37);
                                },
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ],
                            legend: Legend(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                              child: nContainer(
                                context,
                                datosAgrupados,
                                'Hombres', // Título
                                'hombres', // Dato
                                mostrarPorcentaje, // Mostrar según el tipo de estadística seleccionada
                                150, // Ancho
                                totalHombresValparaiso, // Valor extra (total de personas con edad 65 y más)
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarPorcentaje1 = !mostrarPorcentaje1;
                                });
                              },
                              child: nContainer(
                                context,
                                datosAgrupados,

                                'Mujeres', // Título
                                'mujeres', // Dato
                                mostrarPorcentaje1, // Mostrar según el tipo de estadística seleccionada
                                150, // Ancho
                                totalMujeresValparaiso, // Valor extra (total de personas con edad 65 y más)
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: 650,
                          height: 500, // Altura del gráfico
                          child: selectedEstadisticaType == 'total'
                              ? SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  series: <BarSeries>[
                                    BarSeries<GeneroData, String>(
                                      color: Colors
                                          .white, // Cambia el color de las barras a blanco
                                      trackColor: Colors.white,
                                      dataSource: DataTotal_edades,
                                      xValueMapper: (GeneroData data, _) =>
                                          data.genero,
                                      yValueMapper: (GeneroData data, _) =>
                                          data.total,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        textStyle: TextStyle(
                                            fontSize: 20,
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
                                )
                              : SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  primaryYAxis: NumericAxis(
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  series: <BarSeries>[
                                    BarSeries<EdadesData, String>(
                                      color: Colors.white,
                                      trackColor: Colors.white,
                                      dataSource: edadesAgrupado,
                                      xValueMapper: (EdadesData data, _) =>
                                          data.edad,
                                      yValueMapper: (EdadesData data, _) =>
                                          data.total,
                                      dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        textStyle: TextStyle(
                                            fontSize: 20, color: Colors.white),
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
                                  child: nContainer(
                                    context,
                                    datosAgrupados,
                                    'Edad 0 y 5', // Título
                                    'edad_0a5', // Dato
                                    mostrarPorcentaje3, // Mostrar según el tipo de estadística seleccionada
                                    150, // Ancho
                                    totalEdad0_5, // Valor extra (total de personas con edad 65 y más)
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje4 = !mostrarPorcentaje4;
                                    });
                                  },
                                  child: nContainer(
                                    context,
                                    datosAgrupados,
                                    'Edad 6 y 14', // Título
                                    'edad_6a14', // Dato
                                    mostrarPorcentaje4, // Mostrar según el tipo de estadística seleccionada
                                    150, // Ancho
                                    totalEdad6_14, // Valor extra (total de personas con edad 65 y más)
                                  ),
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
                                  child: nContainer(
                                    context,
                                    datosAgrupados,
                                    'Edad 15 y 64', // Título
                                    'edad_15a64', // Dato
                                    mostrarPorcentaje5, // Mostrar según el tipo de estadística seleccionada
                                    150, // Ancho
                                    totalEdad15_64, // Valor extra (total de personas con edad 65 y más)
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mostrarPorcentaje6 = !mostrarPorcentaje6;
                                    });
                                  },
                                  child: nContainer(
                                    context,
                                    datosAgrupados,
                                    'Edad 65 y mas', // Título
                                    'edad_65yma', // Dato
                                    mostrarPorcentaje6, // Mostrar según el tipo de estadística seleccionada
                                    150, // Ancho
                                    totalEdad65, // Valor extra (total de personas con edad 65 y más)
                                  ),
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

  Container nContainer(
    BuildContext context,
    Map<String, dynamic> datosAgrupados, // Cambio 1
    String titulo,
    String dato,
    bool mostrar,
    double ancho,
    int valorExtra, // Nuevo parámetro que representa el valor entero
  ) {
    return Container(
      width: ancho,
      height: MediaQuery.of(context).size.width / 3,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    offset: Offset(0, 20),
                    blurRadius: 30,
                    spreadRadius: -20),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: const [
                  AppColors.cuadro_3,
                  AppColors.cuadro_3,
                  AppColors.cuadro_1,
                  AppColors.cuadro_1,
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
                // Condición para mostrar el valor basado en selectedEstadisticaType
                if (selectedEstadisticaType ==
                    'general') // Solo mostrar si selectedEstadisticaType es 'general'
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      mostrar &&
                              datosAgrupados.containsKey(
                                  selectedCerro) // Verificar si datosAgrupados contiene la clave correspondiente al cerro
                          ? '${((datosAgrupados[selectedCerro]![dato] as int) / (datosAgrupados[selectedCerro]!['total_pers'] as int) * 100).toStringAsFixed(2)}%'
                          : '${datosAgrupados[selectedCerro]![dato]}', // Manejar el caso cuando datosAgrupados no contiene la clave correspondiente al cerro
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                // Nuevo bloque para mostrar el valor entero
                if (selectedEstadisticaType !=
                    'general') // No mostrar si selectedEstadisticaType es diferente de 'general'
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$valorExtra', // Usar el nuevo parámetro
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
