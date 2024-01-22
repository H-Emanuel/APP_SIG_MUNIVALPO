import 'package:flutter/material.dart';
import 'screens/EquipamientoEducativo.dart';
import 'screens/otro_menu.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Informacion de equipamiento Escolar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EquipamientoEducativo()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfiguracionMenu()),
              );
            },
          ),
        ],
      ),
    );
  }
}
