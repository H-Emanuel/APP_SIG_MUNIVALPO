import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:mapa_sig_1/screens/Proyectos.dart';
// import 'package:mapa_sig_1/screens/Proyectos_graficos.dart';
import 'package:mapa_sig_1/screens/infraestructura_critica.dart';
import 'screens/EquipamientoEducativo.dart';
import 'screens/PaginaCenso.dart';
import 'resources/mi_colores.dart';

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
        closedColor: Color.fromARGB(255, 20, 7, 201),
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
                color: AppColors.cuadro_1),
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
        backgroundColor: AppColors.fondo,
        centerTitle: true,
        title: Text(
          'GEOPORTAL MOVIL',
          style: TextStyle(fontSize: 32),
        ),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 20, 4, 242),
                  Color.fromARGB(255, 20, 4, 242),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              children: [
                nContainer(context, 'assets/img/Logo_sig.png'),
                buildListTile(context, 'Educación', Icons.school,
                    EquipamientoEducativo()),
                buildListTile(
                    context, 'Demografia', Icons.people, PaginaCenso()),
                // buildListTile(context, 'EN DESAROLLO ?', Icons.dangerous,
                //     infraestructura_critica()),
                buildListTile(context, 'Proyectos Terminados', Icons.home_work,
                    ProyectoPage()),
                nContainer(context, 'assets/img/LogoAlcaldia.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container nContainer(
    BuildContext context,
    String dirrecion,
  ) {
    return Container(
      width: 10,
      height: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.elliptical(150, 90),
                ),
                color: AppColors.fondo),
          ),
          // Texto
          Positioned(
            bottom: 20,
            left: 15,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(
                image: AssetImage(dirrecion),
                width: 350, // Ancho deseado de la imagen
                height: 200, // Alto deseado de la imagen
              )
            ]),
          ),
        ],
      ),
    );
  }
}
