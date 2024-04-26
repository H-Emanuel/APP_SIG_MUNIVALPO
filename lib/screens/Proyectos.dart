import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProyectoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildExpansionTile(
            'Tipologia A',
            [
              Project(
                'Proyecto 1',
                '\$10,000',
                'Este es el detalle del Proyecto 1. Aquí puedes agregar más información sobre el proyecto.',
              ),
              Project(
                'Proyecto 2',
                '\$12,000',
                'Este es el detalle del Proyecto 2. Aquí puedes agregar más información sobre el proyecto.',
              ),
              Project(
                'Proyecto 3',
                '\$15,000',
                'Este es el detalle del Proyecto 3. Aquí puedes agregar más información sobre el proyecto.',
              ),
              // Agrega más proyectos según sea necesario
            ],
          ),
          SizedBox(height: 16.0),
          _buildExpansionTile(
            'Tipologia B',
            [
              Project(
                'Proyecto A',
                '\$8,000',
                'Este es el detalle del Proyecto A. Aquí puedes agregar más información sobre el proyecto.',
              ),
              Project(
                'Proyecto B',
                '\$9,000',
                'Este es el detalle del Proyecto B. Aquí puedes agregar más información sobre el proyecto.',
              ),
              Project(
                'Proyecto C',
                '\$11,000',
                'Este es el detalle del Proyecto C. Aquí puedes agregar más información sobre el proyecto.',
              ),
              // Agrega más proyectos según sea necesario
            ],
          ),
          SizedBox(height: 20.0),
          _buildCharts(),

          // Agrega más ExpansionTiles según sea necesario
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String typology, List<Project> projects) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          typology,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: projects.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  projects[index].name,
                  style: TextStyle(fontSize: 16.0),
                ),
                subtitle: Text(
                  'Presupuesto: ${projects[index].budget}',
                  style: TextStyle(fontSize: 14.0),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailPage(projects[index]),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Project {
  final String name;
  final String budget;
  final String details;

  Project(this.name, this.budget, this.details);
}

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Presupuesto: ${project.budget}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              project.details,
              style: TextStyle(fontSize: 16.0),
            ),
            // Agrega más detalles del proyecto según sea necesario
          ],
        ),
      ),
    );
  }
}

Widget _buildExpansionPanelList() {
  // Implementa tu ExpansionPanelList aquí
  return Container(
    height: 200.0,
    color: Colors.grey[200],
    child: Center(
      child: Text(
        'ExpansionPanelList',
        style: TextStyle(fontSize: 20.0),
      ),
    ),
  );
}

Widget _buildCharts() {
  // Crea diferentes tipos de gráficos
  return Column(
    children: [
      _buildLineChart(),
      SizedBox(height: 20.0),
      _buildBarChart(),
      SizedBox(height: 20.0),
      _buildPieChart(),
      SizedBox(height: 20.0),
      _buildScatterChart(),
    ],
  );
}

Widget _buildLineChart() {
  // Gráfico de línea simple con datos de ejemplo
  return Container(
    height: 300.0,
    padding: EdgeInsets.all(16.0),
    child: LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 4),
              FlSpot(2, 3.5),
              FlSpot(3, 5),
              FlSpot(4, 4.5),
              FlSpot(5, 6),
              FlSpot(6, 5.5),
              FlSpot(7, 7),
            ],
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    ),
  );
}

Widget _buildBarChart() {
  // Gráfico de barras con datos de ejemplo
  return Container(
    height: 300.0,
    padding: EdgeInsets.all(16.0),
    child: BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        groupsSpace: 20.0,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barsSpace: 12.0,
            barRods: [
              BarChartRodData(y: 5),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barsSpace: 12.0,
            barRods: [
              BarChartRodData(
                y: 7,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barsSpace: 12.0,
            barRods: [
              BarChartRodData(
                y: 6,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildPieChart() {
  // Gráfico circular (de pastel) con datos de ejemplo
  return Container(
    height: 300.0,
    padding: EdgeInsets.all(16.0),
    child: PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 30,
            color: Colors.blue,
            title: 'A',
          ),
          PieChartSectionData(
            value: 40,
            color: Colors.green,
            title: 'B',
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.orange,
            title: 'C',
          ),
        ],
      ),
    ),
  );
}

Widget _buildScatterChart() {
  // Gráfico de dispersión con datos de ejemplo
  return Container(
    height: 300.0,
    padding: EdgeInsets.all(16.0),
    child: ScatterChart(
      ScatterChartData(
        scatterSpots: [
          ScatterSpot(1, 5),
          ScatterSpot(2, 7),
          ScatterSpot(3, 6),
          ScatterSpot(4, 8),
          ScatterSpot(5, 4),
          ScatterSpot(6, 7),
        ],
        minX: 0,
        maxX: 7,
        minY: 0,
        maxY: 10,
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
      ),
    ),
  );
}
