import 'package:flutter/material.dart';
import 'package:mapa_sig_1/data/proyectos.dart';
import 'package:intl/intl.dart';
import 'package:mapa_sig_1/resources/mi_colores.dart';

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
        foregroundColor: AppColors.texto_1,
        backgroundColor: AppColors.fondo,
        title: Text('Proyectos / Lista'),
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
      ),
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
    int totalPresupuesto = 0;
    int cantidadProyectos = projects.length;

    // Calcular la suma total del presupuesto
    for (var project in projects) {
      totalPresupuesto +=
          project.monto ?? 0; // Asegurarse de manejar valores nulos
    }

    // Formatear el total del presupuesto con separador de miles
    String formattedBudget =
        NumberFormat("#,##0", "es_ES").format(totalPresupuesto);

    // Obtener el icono correspondiente a la tipología
    Icon icono = AppIcons.iconosPorTipologia[tipologia] ?? Icon(Icons.error);

    return Card(
      color: AppColors.cuadro_1,
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            SizedBox(height: 8.0),
            Text(
              'Total Proyectos: $cantidadProyectos',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            Text(
              'Total Presupuesto: \$${formattedBudget.toString()}',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ],
        ),
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
        foregroundColor: AppColors.texto_1,
        title: Text("Detalle del Proyecto"),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 140, 255),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            surfaceTintColor: AppColors.texto_1,
            color: Color.fromARGB(255, 0, 107, 194),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    iconColor: AppColors.texto_1,
                    title: Text(
                      'Nombre de la Iniciativa: ${project.nombreIniciativa}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.texto_1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Presupuesto: \$${formattedBudget}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.texto_1,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.search, color: AppColors.texto_1),
                    title: Text(
                      'Tipología: ${project.tipologia}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.view_timeline, color: AppColors.texto_1),
                    title: Text(
                      'Programa: ${project.programa ?? "No disponible"}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.work_outlined, color: AppColors.texto_1),
                    title: Text(
                      'Fuente: ${project.fuente ?? "No disponible"}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.business, color: AppColors.texto_1),
                    title: Text(
                      'ID De Mercado Publico: ${project.idMercado ?? 'Sin ID'}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.calendar_today, color: AppColors.texto_1),
                    title: Text(
                      'Fecha de Contrato: ${project.fechaContrato}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.calendar_today, color: AppColors.texto_1),
                    title: Text(
                      'Fecha de Termino: ${project.fechaTermino}',
                      style:
                          TextStyle(fontSize: 16.0, color: AppColors.texto_1),
                    ),
                  ),
                  // Agrega más ListTiles según sea necesario para otros detalles
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
