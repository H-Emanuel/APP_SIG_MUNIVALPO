import 'package:http/http.dart' as http;
import 'dart:convert';

class Project {
  final int id;
  final int idIniciativa;
  final String nombreIniciativa;
  final String tipologia;
  final String? fuente;
  final String? programa;
  final String? idMercado;
  final int monto;
  final String fechaContrato;
  final String fechaTermino;

  Project({
    required this.id,
    required this.idIniciativa,
    required this.nombreIniciativa,
    required this.tipologia,
    required this.fuente,
    required this.programa,
    required this.idMercado,
    required this.monto,
    required this.fechaContrato,
    required this.fechaTermino,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      idIniciativa: json['idiniciativa'],
      nombreIniciativa: json['nombre_iniciativa'],
      tipologia: json['tipologia'],
      fuente: json['fuente'],
      programa: json['programa'],
      idMercado: json['idmercado'],
      monto: json['monto'],
      fechaContrato: json['fecha_contrato'],
      fechaTermino: json['fecha_termino'],
    );
  }
}

Future<List<Project>> fetchProyectoData() async {
  final baseUrl = 'https://apisig.munivalpo.cl/api';
  final response = await http.get(Uri.parse('$baseUrl/Proyectos/'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
    List<Project> projects = [];
    for (var item in jsonData) {
      projects.add(Project.fromJson(item));
    }
    return projects;
  } else {
    throw Exception('Error al cargar los datos del Proyectos');
  }
}
