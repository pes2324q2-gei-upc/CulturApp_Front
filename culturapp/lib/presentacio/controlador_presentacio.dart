import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
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

<<<<<<< HEAD
  List<Actividad> getActivitats() {return activitats;}

  Future <void> initialice() async { activitats = await controladorDomini.getActivitiesAgenda(); }
}
=======
  Future<void> mostrarMisActividades(BuildContext context, String userID) async { 
    controladorDomini.getUserActivities(userID).then((actividades) => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaActividades(actividades: actividades,),
        ),
      )
    }
    );
  }

  Future<void> mostrarActividades(BuildContext context, String userID) async { 
    controladorDomini.getActivities().then((actividades) => {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaActividades(actividades: actividades,),
        ),
      )
    }
    );
  }

  Future <List<Actividad>> getActivities() async {

    return await controladorDomini.getActivities();

  }
}
>>>>>>> dev.v2
