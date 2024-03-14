import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:flutter/material.dart';



class ControladorPresentacion {

  final controladorDomini = ControladorDomini();

  late final List<Actividad> activitats;

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  List<Actividad> getActivitats() {return activitats;}

  Future <void> initialice() async { activitats = await controladorDomini.getActivitiesAgenda(); }
}