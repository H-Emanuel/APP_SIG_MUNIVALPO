import 'package:flutter/material.dart';
import 'package:mapa_sig_1/resources/mi_colores.dart';
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
        backgroundColor: Color.fromARGB(255, 20, 4, 242),
        title: Text(
          'Educación',
          style: TextStyle(fontSize: 30),
        ),
        foregroundColor: AppColors.texto_1,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    offset: Offset(0, 20),
                                    blurRadius: 30,
                                    spreadRadius: -20,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    AppColors.cuadro_2,
                                    AppColors.cuadro_2,
                                    AppColors.cuadro_3,
                                    AppColors.cuadro_3,
                                  ],
                                  stops: const [0.1, 0.3, 0.9, 1.0],
                                ),
                              ),
                            ),
                            Positioned(
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Totales",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 500,
                        child: SfCircularChart(
                          legend: Legend(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: totalPorTipologia.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                            double porcentaje =
                                (entry.value.value / totalGeneral) * 100;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 250,
                                    height: MediaQuery.of(context).size.width /
                                        3.12,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                offset: Offset(0, 20),
                                                blurRadius: 30,
                                                spreadRadius: -20,
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomCenter,
                                              colors: const [
                                                AppColors.cuadro_2,
                                                AppColors.cuadro_2,
                                                AppColors.cuadro_3,
                                                AppColors.cuadro_3,
                                              ],
                                              stops: const [0.1, 0.3, 0.9, 1.0],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Centra horizontalmente
                                              children: [
                                                Text(
                                                  entry.value.key,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  porcentaje
                                                          .toStringAsFixed(2) +
                                                      "%",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign
                                                      .center, // Alinea el texto al centro horizontal
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
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

// realizar varias cosas se debe enteder
// debe realizar varias cosas teales como entcento cacnonicos
class TotalPorTipologiaData {
  final String tipologia;
  final int total;

  TotalPorTipologiaData(this.tipologia, this.total);
}
