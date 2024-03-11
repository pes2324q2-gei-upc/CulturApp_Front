import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/actividades/actividad.dart';
import 'package:http/http.dart' as http;
FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsuaris() async {
  List usuaris = [];
  CollectionReference crUsuaris = db.collection('Usuari');
  QuerySnapshot qeUsuaris = await crUsuaris.get();
  for (var doc in qeUsuaris.docs) {
    usuaris.add(doc.data());
  }
  return usuaris;
}

Future<void> getActivities() async {


  var snapshot = await db.collection('activity').get();
  var numElementos = snapshot.docs.length;
  // Insertar datos solo si la colección 'activity' tiene más de dos elementos
  if (numElementos < 2) {
    var url = Uri.parse(
        "https://analisi.transparenciacatalunya.cat/resource/rhpv-yr4f.json");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        final act = <String, dynamic>{
          'name': actividad.name,
          'code': actividad.code,
          'categoria': actividad.categoria,
          'latitud': actividad.latitud,
          'longitud': actividad.longitud,
          'data_inici': actividad.data_inici,
          'data_fi': actividad.data_fi,
          'horari': actividad.horari,
          'descripcio': actividad.descripcio
        };
        db.collection('activity').doc(actividad.code).set(act);
      }
    }
  }
}
/* 
import 'package:culturapp/services/firebase_service.dart';

body:FutureBuilder( 
      future: getUsuaris(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ,
            itemBuilder: (context, index) {
              return Text(snapshot.data?[index]['nomusuari']);
           // return Text(snapshot.data?[index]['email']),
            },
          );
        } 
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    ),*/