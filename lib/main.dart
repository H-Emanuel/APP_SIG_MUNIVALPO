import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:mapa_sig_1/screens/Proyectos.dart';
import 'screens/EquipamientoEducativo.dart';
import 'screens/PaginaCenso.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  // Función para crear el diseño compartido (Container)
  Widget buildListTile(
      BuildContext context, String title, IconData icon, Widget route) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16), // Ajusta el espacio vertical y horizontal
      child: OpenContainer(
        closedColor: Color.fromARGB(255, 0, 140, 255),
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Ajusta los bordes redondeados
        ),
        openBuilder: (context, _) => route,
        closedBuilder: (context, VoidCallback openContainer) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 0, 140, 255),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 16), // Ajusta el espacio alrededor de los iconos
              leading: Icon(icon, color: Colors.white),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              tileColor: Colors.transparent, // Color de fondo al presionar
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Esquinas redondeadas
              ),
              onTap: openContainer,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Ajusta la altura deseada aquí
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'GEOPORTAL MOVIL',
            style: TextStyle(fontSize: 32),
          ),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
          shadowColor: Colors.transparent,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 29, 149, 255),
                  Color.fromARGB(255, 17, 168, 24)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              children: [
                buildListTile(context, 'Información De Equipamiento Escolar',
                    Icons.fiber_manual_record_sharp, EquipamientoEducativo()),
                buildListTile(context, 'Censo 2017',
                    Icons.fiber_manual_record_sharp, PaginaCenso()),
                buildListTile(
                    context,
                    'Infraestructura Crítica - En desarrollo',
                    Icons.fiber_manual_record_sharp,
                    PaginaCenso()),
                buildListTile(context, 'Proyectos Terminados',
                    Icons.fiber_manual_record_sharp, ProyectoPage()),
                NContainer(context, "titulo")
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container NContainer(
    BuildContext context,
    String titulo,
  ) {
    return Container(
      width: 10,
      height: MediaQuery.of(context).size.width / 1.08,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.elliptical(150, 90),
                ),
                color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          // Texto
          Positioned(
            bottom: 80,
            left: 15,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Image(
                    image: AssetImage('assets/img/logo sig.png'),
                    width: 180, // Ancho deseado de la imagen
                    height: 150, // Alto deseado de la imagen
                  ),
                  Image(
                    image: AssetImage('assets/img/LogoAlcaldia.png'),
                    width: 180, // Ancho deseado de la imagen
                    height: 150, // Alto deseado de la imagen
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
