import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/controlador_domini.dart';
import 'package:culturapp/domain/models/foro_model.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:culturapp/presentacio/screens/lista_actividades.dart';
import 'package:culturapp/presentacio/screens/login.dart';
import 'package:culturapp/presentacio/screens/map_screen.dart';
import 'package:culturapp/presentacio/screens/my_activities.dart';
import 'package:culturapp/presentacio/screens/perfil_screen.dart';
//import 'package:culturapp/presentacio/screens/recomendador_actividades.dart';
import 'package:culturapp/presentacio/screens/settings_perfil.dart';
import 'package:culturapp/presentacio/screens/signup.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_mis_actividades.dart';
import 'package:culturapp/presentacio/screens/vista_ver_actividad.dart';
import 'package:culturapp/presentacio/screens/xats.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ControladorPresentacion {

  final controladorDomini = ControladorDomini();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late List<Actividad> activitats;
  late List<Actividad> activitatsUser;
  late List<String> recomms;
  late List<String> categsFav = [];
  late final List<Widget> _pages = [];

  //Future <void> initialice() async => activitats = await controladorDomini.getActivitiesAgenda(); 

  Future<void> initialice() async {
    activitats = await controladorDomini.getActivitiesAgenda();
  }

  Future<void> initialice2() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
    }

    if (userLogged()) {
      categsFav = await controladorDomini.obteCatsFavs(_user);
      activitatsUser = await controladorDomini.getUserActivities(_user!.uid);
    }

    _pages.addAll([
      MapPage(controladorPresentacion: this),
      ListaMisActividades(controladorPresentacion: this),
      const Xats(),
      PerfilPage(controladorPresentacion: this),
    ]);
  }

  bool userLogged() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      return true;
    } else {
      return false;
    }
  }

  void mostrarVerActividad(BuildContext context, List<String> info_act, Uri uri_act) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaVerActividad(info_actividad: info_act, uri_actividad: uri_act),
      ),
    );
  }

  Widget getPage(int index) {
    return _pages[index];
  }

  Future<void> mostrarMisActividades(BuildContext context) async {
    getUserActivities(_user!.uid).then((actividades) => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListaMisActividades(
                controladorPresentacion: this,
              ),
            ),
          )
        });
  }

  Future<void> obtenerActividadesUser() async {
    activitatsUser = await getUserActivities(_user!.uid);
  }

  void mostrarActividades(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaActividadesDisponibles(
          actividades: activitats,
          controladorPresentacion: this,
        ),
      ),
    );
  }

  void mostrarMapaActividades(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(
          controladorPresentacion: this,
        ),
      ),
    );
  }

  List<Actividad> getActivitats() => activitats;

  List<Actividad> getActivitatsUser() => activitatsUser;

  /*
  List<String> getActivitatsRecomm() {
    recomms = calcularActividadesRecomendadas(categsFav, activitats);
    return recomms;
  }
  */

  Future<List<Actividad>> getUserActivities(String userID) => controladorDomini.getUserActivities(userID);

  FirebaseAuth getFirebaseAuth() {
    return _auth;
  }

  void setUser(User? event) {
    _user = event;
  }

  User? getUser() {
    return _user;
  }

  Future<List<Actividad>> searchActivitat(String squery) {
    return controladorDomini.searchActivitat(squery);
  }

  Future<List<Actividad>> searchMyActivitats(String name) {
    return controladorDomini.searchMyActivities(_user!.uid, name);
  }

  void checkLoggetInUser(BuildContext context) {
     //Obte l'usuari autentificat en el moment si existeix
    User? currentUser = _auth.currentUser;
    
    //Si existeix l'usuari, estableix l'usuari de l'estat i redirigeix a la pantalla principal
    if (currentUser != null) {
      _user = currentUser;
      mostrarMapaActividades(context);
    }
  }

  handleGoogleSignIn(BuildContext context) async {
    try {
      //Iniciar la sessio amb el compte especificat per l'usuari
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(_googleAuthProvider);
      bool userExists = await controladorDomini.accountExists(userCredential.user);
      _user = userCredential.user;
      
      //Si no hi ha un usuari associat al compte de google, redirigir a la pantalla de registre
      if (!userExists) { mostrarSignup(context);}
      //Altrament redirigir a la pantalla principal de l'app
      else mostrarMapaActividades(context);
    }
    catch (error) {
      print(error);
    }
  }
  
  void mostrarSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Signup(controladorPresentacion: this),
      ),
    );
  }
  
  void mostrarLogin(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(controladorPresentacion: this),
        ),
    );
  }

  void createUser(String username, List<String> selectedCategories, BuildContext context) async {
    controladorDomini.createUser(_user, username, selectedCategories);
    mostrarPerfil(context);
  }

  void mostrarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerfilPage(controladorPresentacion: this),
      ),
    );
  }

  void mostrarSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPerfil(controladorPresentacion: this),
      ),
    );
  }

  void logout(context) {
    _auth.signOut();
    mostrarLogin(context);
  }


  //funcions del forum
  Future<void> getForo(String code) async {
    try {
      Foro? foro = await controladorDomini.foroExists(code);
      if (foro != null) {
        // El foro existe, imprimir sus detalles
        print('Foro existente: $foro');
      } else {
        // El foro no existe, crear uno nuevo
        bool creadoExitosamente = await controladorDomini.createForo(code);
        if (creadoExitosamente) {
          print('Nuevo foro creado');
        } else {
          print('Error al crear el foro');
        }
      }
    } catch (error) {
      print('Error al obtener o crear el foro: $error');
    }
  }

  Future<String?> getForoId(String activitatCode) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('foros')
          .where('activitat_code', isEqualTo: activitatCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Si hay al menos un documento con el código de actividad dado
        return querySnapshot.docs.first.id; // Devuelve el ID del primer documento
      } else {
        // Si no se encontró ningún documento con el código de actividad dado
        return null;
      }
    } catch (error) {
      // Si ocurre algún error al obtener el ID del foro
      print('Error al obtener el ID del foro: $error');
      return null;
    }
  }

}
