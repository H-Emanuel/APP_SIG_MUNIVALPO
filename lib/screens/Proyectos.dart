import 'package:flutter/material.dart';
import 'package:mapa_sig_1/data/proyectos.dart';

class ProyectoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        title: Text('Proyectos'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 140, 255),
        child: FutureBuilder<List<Project>>(
          future: fetchProyectoData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            } else {
              List<Project> projects = snapshot.data!;
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
      ),
    );
  }

  Widget _buildExpansionTile(
      BuildContext context, String tipologia, List<Project> projects) {
    return Card(
      color: Color.fromARGB(255, 16, 206, 108),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Text(
          tipologia,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        children: projects.map((project) {
          String projectName = project.nombreIniciativa;
          if (projectName.length > 28) {
            projectName = projectName.substring(0, 25) + '...';
          }
          return ListTile(
            title: Text(
              projectName,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            subtitle: Text(
              'Presupuesto: \$${project.monto}',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              _navigateToProjectDetailPage(context, project);
            },
          );
        }).toList(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(project.nombreIniciativa),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Presupuesto: \$${project.monto}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tipología: ${project.tipologia}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fuente: ${project.fuente}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fecha de Contrato: ${project.fechaContrato}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fecha de Término: ${project.fechaTermino}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
