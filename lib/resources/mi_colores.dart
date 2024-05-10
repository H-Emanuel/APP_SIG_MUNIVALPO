import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppColors {
  static const Color texto_1 = Colors.white;
  static const Color texto_2 = Colors.white70;
  static const Color texto_3 = Colors.white38;

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color fondo = Color.fromARGB(255, 20, 4, 242);
  static const Color cuadro_1 = Color.fromARGB(255, 12, 0, 177);
  static const Color cuadro_2 = Color.fromARGB(255, 52, 38, 255);
  static const Color cuadro_3 = Color.fromARGB(255, 30, 54, 191);
}

class AppIcons {
  static const Map<String, Icon> iconosPorTipologia = {
    'Salud': Icon(
      Icons.local_hospital,
      color: Colors.white,
      size: 45.0,
    ),
    'Espacios Públicos': Icon(
      FontAwesomeIcons.treeCity,
      color: Colors.white,
      size: 45.0,
    ),
    'Edificación Pública': Icon(
      FontAwesomeIcons.city,
      color: Colors.white,
      size: 45.0,
    ),
    'Vialidad y Transporte': Icon(
      FontAwesomeIcons.bus,
      color: Colors.white,
      size: 45.0,
    ),
    'Energía y Seguridad': Icon(
      FontAwesomeIcons.bolt,
      color: Colors.white,
      size: 45.0,
    ),
    'Equip. Comunitario': Icon(
      FontAwesomeIcons.peopleGroup,
      color: Colors.white,
      size: 45.0,
    ),
    'Deporte': Icon(
      FontAwesomeIcons.futbol,
      color: Colors.white,
      size: 45.0,
    ),
    'Vialidad Peatonal': Icon(
      FontAwesomeIcons.personWalking,
      color: Colors.white,
      size: 50.0,
    ),
    'Vivienda': Icon(
      Icons.house,
      color: Colors.white,
      size: 45.0,
    ),
    'Cultura y Patrimonio': Icon(
      FontAwesomeIcons.masksTheater,
      color: Colors.white,
      size: 45.0,
    ),
  };
}
