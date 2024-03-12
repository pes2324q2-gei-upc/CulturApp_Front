import 'package:culturapp/controlador_presentacion.dart';
import 'package:culturapp/map/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ControladorPresentacion controladorPresentacion = ControladorPresentacion();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MapPage(controladorPresentacion: controladorPresentacion),
    );
  }
}