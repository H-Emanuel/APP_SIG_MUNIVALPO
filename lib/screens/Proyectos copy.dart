import 'package:flutter/material.dart';
import 'package:mapa_sig_1/data/proyectos.dart';
import 'package:intl/intl.dart';

class ProyectoPage extends StatefulWidget {
  @override
  _ProyectoPageState createState() => _ProyectoPageState();
}

class _ProyectoPageState extends State<ProyectoPage> {
  List<String> _tipologias = [];
  List<String> _selectedTipologias = [];
  late Future<List<Project>> _fetchProjects;

  @override
  void initState() {
    super.initState();
    _fetchProjects = fetchProyectoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        title: Text('Proyectos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'lista') {
              } else if (value == 'graficos') {}
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
                value: 'graficos',
                child: ListTile(
                  leading: Icon(Icons.insert_chart),
                  title: Text('Ver Gráficos'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 140, 255),
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
      ),
      floatingActionButton: _buildFilterDropdown(),
    );
  }

  Widget _buildFilterDropdown() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Seleccionar Tipologías'),
                  content: Container(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ..._tipologias.map((tipologia) {
                            return CheckboxListTile(
                              title: Text(tipologia),
                              value: _selectedTipologias.contains(tipologia),
                              onChanged: (selected) {
                                setState(() {
                                  if (selected!) {
                                    _selectedTipologias.add(tipologia);
                                  } else {
                                    _selectedTipologias.remove(tipologia);
                                  }
                                });
                              },
                            );
                          }).toList(),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedTipologias.clear();
                              });
                            },
                            child: Text('Limpiar filtros'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // Cerrar el diálogo
                        Navigator.pop(context);
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Cerrar el diálogo
                        Navigator.pop(context);

                        // Actualizar los proyectos
                        setState(() {
                          _fetchProjects = fetchProyectoData();
                        });
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      child: Icon(Icons.filter_alt),
    );
  }

  Widget _buildExpansionTile(
      BuildContext context, String tipologia, List<Project> projects) {
    return Card(
      color: Color.fromARGB(255, 35, 129, 237),
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

          // Formatear el presupuesto
          String formattedBudget =
              NumberFormat("#,##0", "es_ES").format(project.monto);

          return ListTile(
            title: Text(
              projectName,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            subtitle: Text(
              'Presupuesto: \$${formattedBudget}',
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
    String formattedBudget =
        NumberFormat("#,##0", "es_ES").format(project.monto);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
        foregroundColor: Colors.white,
        title: Text("Detalle del Proyecto"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 140, 255),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            color: Color.fromARGB(255, 0, 107, 194),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre de la Iniciativa: ${project.nombreIniciativa}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Presupuesto: \$${formattedBudget}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Tipología: ${project.tipologia}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Programa: ${project.programa ?? "No disponible"}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Fuente: ${project.fuente ?? "No disponible"}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Fecha de Contrato: ${project.fechaContrato}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Fecha de Término: ${project.fechaTermino}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  'ID de Mercado Publico: ${project.idMercado ?? "No disponible"}',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
