import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class CustomPopup extends StatefulWidget {
  final Marker marker; // Puedes agregar más propiedades según tus necesidades

  CustomPopup({required this.marker, Key? key}) : super(key: key);

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Acción al tocar la ventana emergente
          // Puedes agregar lógica personalizada aquí
        },
        child: Column(
          children: <Widget>[
            Text(
              'Información personalizada',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(
              'Latitud: ${widget.marker.point.latitude}',
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Longitud: ${widget.marker.point.longitude}',
              style: TextStyle(fontSize: 14.0),
            ),
            // Agrega más información según tus necesidades
          ],
        ),
      ),
    );
  }
}
