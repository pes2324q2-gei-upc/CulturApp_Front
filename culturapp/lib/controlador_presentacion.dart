
import 'package:culturapp/actividad.dart';
import 'package:culturapp/controlador_presistencia.dart';
import 'package:culturapp/vista_ver_actividad.dart';
import 'package:flutter/material.dart';



class ControladorPresentacion {

  final controladorPersistencia = ControladorPersistencia();

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  Future <List<Actividad>> getActivities() async {

    return await controladorPersistencia.getActivities();

  }
}