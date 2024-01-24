import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'screens/EquipamientoEducativo.dart';
import 'screens/otro_menu.dart';
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
        closedColor: Colors.blue,
        transitionDuration: Duration(milliseconds: 500),
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(21.0), // Ajusta los bordes redondeados
        ),
        openBuilder: (context, _) => route,
        closedBuilder: (context, VoidCallback openContainer) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 0, 174, 255),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Menu Informacion'),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(80))),
        shadowColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: Container(
            child: Icon(
              Icons.pause_outlined,
              size: 100,
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(left: 30, bottom: 40),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 120, 215), Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            buildListTile(context, 'Información de equipamiento Escolar',
                Icons.school, EquipamientoEducativo()),
            buildListTile(context, 'Datos de tercera Edad', Icons.people,
                ConfiguracionMenu()),
            buildListTile(context, 'Censo ', Icons.fiber_manual_record_sharp,
                PaginaCenso()),
          ],
        ),
      ),
    );
  }
}
