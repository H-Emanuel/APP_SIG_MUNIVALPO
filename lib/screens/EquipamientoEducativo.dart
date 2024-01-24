import 'package:flutter/material.dart';
import '/data/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fancy_containers/fancy_containers.dart';

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
        title: Text('Equipamiento Educativo'),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
                  .map((entry) => TotalPorTipologiaData(entry.key, entry.value))
                  .toList();

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue, Colors.indigo],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 650,
                      height: 500, // Altura del gráfico
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          RadialBarSeries<TotalPorTipologiaData, String>(
                            dataSource: chartData,
                            xValueMapper: (TotalPorTipologiaData data, _) =>
                                data.tipologia,
                            yValueMapper: (TotalPorTipologiaData data, _) =>
                                data.total,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          ),
                        ],
                        legend: Legend(
                            textStyle: TextStyle(color: Colors.white),
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap),
                      ),
                    ),

                    // Cuadro de colores con porcentajes
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centra horizontalmente
                          children: totalPorTipologia.entries.map((entry) {
                            double porcentaje =
                                (entry.value / totalGeneral) * 100;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .center, // Centra horizontalmente
                                  children: [
                                    FancyContainer(
                                      height: 150,
                                      width: 300,
                                      title: entry.key,
                                      color1: Color.fromARGB(255, 0, 183, 255),
                                      color2: Colors.blue,
                                      textColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                      subtitle:
                                          porcentaje.toStringAsFixed(2) + "%",
                                      subtitleColor:
                                          Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    // Puedes ajustar el espacio horizontal aquí si es necesario
                                    SizedBox(width: 8),
                                  ],
                                ),
                                // Puedes ajustar el espacio vertical aquí si es necesario
                                SizedBox(height: 15),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
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
