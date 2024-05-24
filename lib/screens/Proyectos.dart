import 'package:flutter/material.dart';
import 'package:mapa_sig_1/data/proyectos.dart';
import 'package:intl/intl.dart';
import 'package:mapa_sig_1/resources/mi_colores.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartData {
  final String tipologia;
  final int count;

  PieChartData(this.tipologia, this.count);
}

class ProyectoPage extends StatefulWidget {
  @override
  _ProyectoPageState createState() => _ProyectoPageState();
}

class _ProyectoPageState extends State<ProyectoPage> {
  List<String> _tipologias = [];
  List<String> _selectedTipologias = [];
  String selectedView = 'lista';
  late Future<List<Project>> _fetchProjects;

  @override
  void initState() {
    super.initState();
    _fetchProjects = fetchProyectoData();
  }

  Widget build(BuildContext context) {
    Widget bodyWidget = SizedBox();

    // Dependiendo del valor de selectedView, asignamos el widget correspondiente a bodyWidget
    if (selectedView == 'lista') {
      bodyWidget = lista();
    } else if (selectedView == 'otraVista') {
      bodyWidget = otroWidget();
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.texto_1,
        backgroundColor: AppColors.fondo,
        title: Text('Proyectos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedView = value; // Actualizamos la vista seleccionada
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'lista',
                child: ListTile(
                  leading: Icon(Icons.list),
                  title: Text('Ver Lista'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'otraVista',
                child: ListTile(
                  leading: Icon(Icons.insert_chart),
                  title: Text('Ver Otra Vista'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: bodyWidget, // Mostramos el widget correspondiente
    );
  }

  Container lista() {
    return Container(
      color: AppColors.fondo,
      child: FutureBuilder<List<Project>>(
        future: _fetchProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else {
            List<Project> projects = snapshot.data!;

            // Filtrar los proyectos si se han seleccionado tipologías
            if (_selectedTipologias.isNotEmpty) {
              projects = projects
                  .where((project) =>
                      _selectedTipologias.contains(project.tipologia))
                  .toList();
            }

            // Obtener todas las tipologías disponibles
            _tipologias =
                projects.map((project) => project.tipologia).toSet().toList();

            Map<String, List<Project>> groupedProjects = {};

            // Agrupar los proyectos por tipología
            for (var project in projects) {
              if (!groupedProjects.containsKey(project.tipologia)) {
                groupedProjects[project.tipologia] = [];
              }
              groupedProjects[project.tipologia]!.add(project);
            }

            // Construir la lista agrupada
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: groupedProjects.entries.map((entry) {
                return _buildExpansionTile(context, entry.key, entry.value);
              }).toList(),
            );
          }
        },
      ),
    );
  }

  SingleChildScrollView otroWidget() {
    return SingleChildScrollView(
      // Envuelve el contenedor con SingleChildScrollView
      child: Container(
        color: AppColors.fondo,
        padding: EdgeInsets.symmetric(
            vertical: 20.0), // Espacio adicional arriba y abajo
        child: FutureBuilder<List<Project>>(
          future: _fetchProjects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay datos disponibles'));
            } else {
              List<Project> projects = snapshot.data!;

              // Generar datos para el gráfico de tipología
              List<PieChartData> tipologiaChartData = _generateChartData(
                projects,
                (project) => project.tipologia,
              );

              // Generar datos para el gráfico de fuentes
              List<PieChartData> fuenteChartData = _generateChartData(
                projects,
                (project) => project.fuente,
              );

              // Generar datos para el gráfico de programas
              List<PieChartData> programaChartData = _generateChartData(
                projects,
                (project) => project.programa,
              );

              return Column(
                children: [
                  _buildPieChart(
                    'Distribución por Tipología',
                    tipologiaChartData,
                  ),
                  SizedBox(height: 5), // Espacio entre los gráficos
                  _buildPieChart(
                    'Distribución por Fuente',
                    fuenteChartData,
                  ),
                  SizedBox(height: 5), // Espacio entre los gráficos
                  _buildPieChart(
                    'Distribución por Programa',
                    programaChartData,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPieChart(String title, List<PieChartData> chartData) {
    return Container(
      width: 800, // Ancho deseado
      height: 800, // Alto deseado

      padding: EdgeInsets.all(1.0),
      child: SfCircularChart(
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(
            color: AppColors.texto_1,
          ),
        ),
        legend: Legend(
          textStyle: TextStyle(
            color: AppColors.texto_1,
            fontSize: 15,
          ),
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        series: <PieSeries<PieChartData, String>>[
          PieSeries<PieChartData, String>(
            dataSource: chartData,
            xValueMapper: (PieChartData data, _) => data.tipologia,
            yValueMapper: (PieChartData data, _) => data.count,
            dataLabelMapper: (PieChartData data, _) => '${data.count}',
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  List<PieChartData> _generateChartData(
      List<Project> projects, String? Function(Project) mapper) {
    Map<String, int> countMap = {};

    // Contar la cantidad de proyectos según el mapeo
    for (var project in projects) {
      String value = mapper(project) ??
          'Sin especificar'; // Valor predeterminado si es nulo
      countMap[value] = (countMap[value] ?? 0) + 1;
    }

    // Convertir a lista de datos para el gráfico
    return countMap.entries
        .map((entry) => PieChartData(entry.key, entry.value))
        .toList();
  }

  // Widget _buildExpansionTile(
  //     BuildContext context, String tipologia, List<Project> projects) {
  //   int totalPresupuesto = 0;
  //   int cantidadProyectos = projects.length;

  //   // Calcular la suma total del presupuesto
  //   for (var project in projects) {
  //     totalPresupuesto += project.monto; // Asegurarse de manejar valores nulos
  //   }

  //   // Formatear el total del presupuesto con separador de miles
  //   String formattedBudget =
  //       NumberFormat("#,##0", "es_ES").format(totalPresupuesto);

  //   // Obtener el icono correspondiente a la tipología
  //   Icon icono = AppIcons.iconosPorTipologia[tipologia] ?? Icon(Icons.error);

  //   return Card(
  //     color: AppColors.cuadro_1,
  //     elevation: 4.0,
  //     margin: EdgeInsets.symmetric(vertical: 8.0),
  //     child: Container(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   SizedBox(width: 8.0), // Espacio entre el icono y el texto
  //                   Text(
  //                     tipologia,
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               // Usar un contenedor vacío para mantener el tamaño del icono
  //               SizedBox(
  //                 width: 48.0,
  //                 height: 48.0,
  //                 child: icono, // Usar el icono como hijo del contenedor
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 8.0),
  //           Text(
  //             'Total Proyectos: $cantidadProyectos',
  //             style: TextStyle(fontSize: 14.0, color: Colors.white),
  //           ),
  //           Text(
  //             'Total Presupuesto: \$${formattedBudget.toString()}',
  //             style: TextStyle(fontSize: 14.0, color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildExpansionTile(
      BuildContext context, String tipologia, List<Project> projects) {
    int totalPresupuesto = 0;
    int cantidadProyectos = projects.length;

    // Calcular la suma total del presupuesto
    for (var project in projects) {
      totalPresupuesto += project.monto; // Asegurarse de manejar valores nulos
    }

    // Formatear el total del presupuesto con separador de miles
    String formattedBudget =
        NumberFormat("#,##0", "es_ES").format(totalPresupuesto);

    // Obtener el icono correspondiente a la tipología
    Icon icono = AppIcons.iconosPorTipologia[tipologia] ?? Icon(Icons.error);

    return Card(
      color: AppColors.cuadro_1,
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ExpansionTile(
        iconColor: AppColors.texto_1,
        collapsedIconColor: AppColors.texto_1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 8.0), // Espacio entre el icono y el texto
                Text(
                  tipologia,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Usar un contenedor vacío para mantener el tamaño del icono
            SizedBox(
              width: 48.0,
              height: 48.0,
              child: icono, // Usar el icono como hijo del contenedor
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.0),
              Text(
                'Total Proyectos: $cantidadProyectos',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Presupuesto: \$${formattedBudget.toString()}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...projects.map((project) {
                String projectName = project.nombreIniciativa;
                if (projectName.length > 28) {
                  projectName = projectName.substring(0, 25) + '...';
                }

                // Formatear el presupuesto
                String formattedBudget =
                    NumberFormat("#,##0", "es_ES").format(project.monto);

                return ListTile(
                  title: Text(
                    projectName,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Presupuesto: \$${formattedBudget}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.texto_1,
                  ),
                  onTap: () {
                    _navigateToProjectDetailPage(context, project);
                  },
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToProjectDetailPage(BuildContext context, Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailPage(project),
      ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage(this.project);

  @override
  Widget build(BuildContext context) {
    String formattedBudget =
        NumberFormat("#,##0", "es_ES").format(project.monto);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.fondo,
        foregroundColor: AppColors.texto_1,
        title: Text("Detalle del Proyecto"),
      ),
      body: Container(
        color: AppColors.fondo,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              color: AppColors.cuadro_1,
              elevation: 8.0,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Nombre de la Iniciativa: ${project.nombreIniciativa}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.texto_1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          'Presupuesto: \$${formattedBudget}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.texto_1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      ListTile(
                        leading: Icon(Icons.auto_awesome_motion_sharp,
                            color: AppColors.texto_1),
                        title: Text(
                          'Tipología',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.tipologia,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.work_rounded, color: AppColors.texto_1),
                        title: Text(
                          'Programa',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.programa ?? "No disponible",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.business_center_rounded,
                            color: AppColors.texto_1),
                        title: Text(
                          'Fuente',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.fuente ?? "No disponible",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.date_range, color: AppColors.texto_1),
                        title: Text(
                          'Fecha de Contrato',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.fechaContrato,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.date_range, color: AppColors.texto_1),
                        title: Text(
                          'Fecha de Término',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.fechaTermino,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.info, color: AppColors.texto_1),
                        title: Text(
                          'ID de Mercado Publico',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.texto_1,
                          ),
                        ),
                        subtitle: Text(
                          project.idMercado ?? "No disponible",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
