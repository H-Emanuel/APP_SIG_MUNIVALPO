import 'package:flutter/material.dart';
import '/data/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EquipamientoEducativo extends StatefulWidget {
  @override
  _EquipamientoEducativoState createState() => _EquipamientoEducativoState();
}

class _EquipamientoEducativoState extends State<EquipamientoEducativo> {
  final ApiService _apiService =
      ApiService(baseUrl: 'https://apisig.munivalpo.cl/api');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Equipamiento Educativo 1'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: FutureBuilder(
            future: _apiService.fetchEquipamientos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, dynamic>> equipamientos =
                    snapshot.data as List<Map<String, dynamic>>;

                // Calcular la totalidad por tipología
                Map<String, int> totalPorTipologia = {};
                int totalGeneral = 0;

                equipamientos.forEach((equipamiento) {
                  String tipologia = equipamiento['tipologia'];
                  totalPorTipologia[tipologia] =
                      (totalPorTipologia[tipologia] ?? 0) + 1;
                  totalGeneral += 1;
                });

                // Datos para el gráfico de torta
                final List<TotalPorTipologiaData> chartData = totalPorTipologia
                    .entries
                    .map((entry) =>
                        TotalPorTipologiaData(entry.key, entry.value))
                    .toList();

                return Center(
                  child: Column(
                    children: [
                      Container(
                        width: 320,
                        height: MediaQuery.of(context).size.width / 3,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    offset: const Offset(0, 20),
                                    blurRadius: 30,
                                    spreadRadius: -20,
                                  ),
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
                            Positioned(
                              bottom: 35,
                              left: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Equipamiento Educativo Totales ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    totalGeneral.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 500,
                        child: SfCircularChart(
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap),
                          series: <CircularSeries>[
                            PieSeries<TotalPorTipologiaData, String>(
                              dataSource: chartData,
                              xValueMapper: (TotalPorTipologiaData data, _) =>
                                  data.tipologia,
                              yValueMapper: (TotalPorTipologiaData data, _) =>
                                  data.total,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: totalPorTipologia.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            double porcentaje =
                                (entry.value.value / totalGeneral) * 100;
                            return Column(
                              children: [
                                Container(
                                  width: 320,
                                  height: MediaQuery.of(context).size.width / 3,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              offset: const Offset(0, 20),
                                              blurRadius: 30,
                                              spreadRadius: -20,
                                            ),
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
                                      Positioned(
                                        bottom: 35,
                                        left: 25,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              entry.value.key,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              porcentaje.toStringAsFixed(2) +
                                                  "%",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

// Clase para almacenar datos para el gráfico de torta
class TotalPorTipologiaData {
  final String tipologia;
  final int total;

  TotalPorTipologiaData(this.tipologia, this.total);
}
