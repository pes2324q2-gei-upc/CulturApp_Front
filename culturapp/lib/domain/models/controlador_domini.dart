import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/foro_model.dart';
import 'package:culturapp/domain/models/post.dart';
import 'package:culturapp/domain/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserLogged{
  late String tokenUserLogged;
  late String usernameUserLogged;

  void setToken(String token){
    tokenUserLogged = token;
  }

  String getToken(){
    return tokenUserLogged;
  }

  void setUsername(String username){
    usernameUserLogged = username;
  }

  String getUsername(){
    return usernameUserLogged;
  }
}

class ControladorDomini {
  final String ip = "10.0.2.2";
  final UserLogged userLogged = UserLogged();


  Future<void> setInfoUserLogged(String uid) async {
    final respuesta = await http.get(Uri.parse('https://culturapp-back.onrender.com/users/infoToken'),
    headers: {'Authorization' : 'Bearer $uid'});

    if (respuesta.statusCode == 200) {
      var data = json.decode(respuesta.body);
        userLogged.setToken(data['token']);
        userLogged.setUsername(data['username']);
      
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<bool> accountExists(User? user) async {
    print(user?.uid);
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/exists?uid=${user?.uid}'));
       
      print(respuesta.statusCode);
      print(respuesta.body);
    if (respuesta.statusCode == 200) {
      return (respuesta.body == "exists");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<bool> createUser(User? user, String username, List<String> selectedCategories) async {
    try {

      final Map<String, dynamic> userdata = {
        'uid': user?.uid,
        'username': username,
        'email': user?.email,
        'favcategories': selectedCategories
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/create'),
        body: jsonEncode(userdata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
        setInfoUserLogged(user!.uid);
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }

    return true;
  }

  void editUser(User? user, String username, List<String> selectedCategories) async {
    try {
      final Map<String, dynamic> userdata = {
        'uid': user?.uid,
        'username': username,
        'favcategories': jsonEncode(selectedCategories),
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/edit'), 
        body: jsonEncode(userdata),
        headers: {'Authorization': 'Bearer ${userLogged.getToken()}',
                  'Content-Type': 'application/json'},
        );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  Future<bool> usernameUnique(String username) async {
    final respuesta = await http.get(Uri.parse(
        'https://culturapp-back.onrender.com/users/uniqueUsername?username=$username'));

    if (respuesta.statusCode == 200) {
      print(respuesta);
      return (respuesta.body == "unique");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> obteCatsFavs(String username) async {
    final respuesta = await http
        .get(Uri.parse('https://culturapp-back.onrender.com/users/${username}/favcategories')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );
    List<String> categorias = [];

    if (respuesta.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(respuesta.body);
      categorias = jsonResponse.cast<String>();
    }
    return categorias;
  }

  Future<List<Actividad>> getActivitiesAgenda() async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/read/all')
          , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
          }
        );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }
  
  Future<List<Usuario>> getUsers() async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/users/read/users')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list_user(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> getUserActivities() async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/${userLogged.getUsername()}/activitats'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchMyActivities(String name) async {
    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/users/activitats/search/$name'), //FALTA AÑADIR TOKENS
    headers: {
      'Authorization': 'Bearer ${userLogged.getToken()}',
    });

    if (respuesta.statusCode == 200) {
      return _convert_database_to_list(respuesta);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No existe la actividad $name');
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<Actividad>> searchActivitat(String squery) async {
    final respuesta =
        await http.get(Uri.parse('https://culturapp-back.onrender.com/activitats/name/$squery')
        , headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        }
        );

    if (respuesta.statusCode == 200) {
      //final List<dynamic> responseData = jsonDecode(respuesta.body);
      //return Actividad.fromJson(responseData.first);
      return _convert_database_to_list(respuesta);
    } else if (respuesta.statusCode == 404) {
      throw Exception('No existe la actividad ' + squery);
    } else {
      throw Exception('Fallo en buscar la actividad');
    }
  }

  Future<bool> isUserInActivity(String? uid, String code) async {
    final respuesta = await http.get(Uri.parse(
        'https://culturapp-back.onrender.com/users/activitats/isuserin?id=$uid&activityId=$code'),
        headers: {
          'Authorization': 'Bearer ${userLogged.getToken()}',
        } 
        );

    if (respuesta.statusCode == 200) {
      return (respuesta.body == "yes");
    } else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  void signupInActivity(String? uid, String code) async {
    try {
      final Map<String, dynamic> requestData = {
        'uid': uid,
        'activityId': code,
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/activitats/signup'),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${userLogged.getToken()}',
                },
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }
  }

  Future<List<dynamic>> obteFollows(String username, String endpoint) async {
      final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/amics/$username/$endpoint'),
      headers: {
      'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );
    if (respuesta.statusCode == 200) {
      final body = respuesta.body;
      final List<dynamic> data = json.decode(body);
      return data;
    } 
    else {
      throw Exception('Fallo la obtención de datos');
    }
  }

  Future<List<String>> getRequestsUser() async {

    final respuesta = await http.get(
      Uri.parse('https://culturapp-back.onrender.com/amics/followingRequests'), 
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );
    if(respuesta.statusCode == 200) {
      final body = respuesta.body;
      final List<dynamic> data = json.decode(body);
      final List<String> users = data.map((user) => user['friend'].toString()).toList(); 
      return users;
    }
    else {
      throw Exception('Fallo la obtención de datos' /*"data_error_msg".tr(context)*/);
    }
  }

  Future<void> acceptFriend(String person) async {
    final http.Response response = await http.put(
      Uri.parse('https://culturapp-back.onrender.com/amics/accept/$person'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al aceptar al usuario');
  }

  Future<void> deleteFriend(String person) async {
    final http.Response response = await http.delete(
      Uri.parse('https://culturapp-back.onrender.com/amics/delete/$person'),
      headers: {
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
    );

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
  }

  Future<void> createFriend(String person) async {
    final Map<String, dynamic> body = {
        'friend': person,
      };

    final http.Response response = await http.post(
      Uri.parse('https://culturapp-back.onrender.com/amics/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userLogged.getToken()}',
      },
      body: jsonEncode(body),
    );

    print(response.body);

    if (response.statusCode != 200) throw Exception('Error al eliminar al usuario');
  }

  void signoutFromActivity(String? uid, String code) async {
    try {
      final Map<String, dynamic> requestData = {
        'uid': uid,
        'activityId': code,
      };

      final respuesta = await http.post(
        Uri.parse('https://culturapp-back.onrender.com/users/activitats/signout'),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${userLogged.getToken()}',},
      );

      if (respuesta.statusCode == 200) {
        print('Datos enviados exitosamente');
      } else {
        print('Error al enviar los datos: ${respuesta.statusCode}');
      }
    } catch (error) {
      print('Error de red: $error');
    }

  }

  Future<int> sendReportBug(String titulo, String reporte) async {

      final Map<String, dynamic> body = {
        'titol': titulo,
        'report': reporte,
      };

      try {
        final response = await http.post(
          Uri.parse('https://culturapp-back.onrender.com/tickets/reportBug/create'),
          headers: {
            'Content-Type': 'application/json', 
            'Authorization': 'Bearer ${userLogged.getToken()}',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          print('Reporte enviado exitosamente');
        } else {
          print('Error al enviar el reporte: ${response.body}');
        }
        return response.statusCode;
      } catch (e) {
        print(e);
        return 500;
      }
  }

  Future<int> sendOrganizerApplication(String titol, String idActivitat, String motiu) async {

      final Map<String, dynamic> body = {
        'titol': titol,
        'idActivitat': idActivitat,
        'motiu': motiu,
      };

      try {
        final response = await http.post(
          Uri.parse('https://culturapp-back.onrender.com/tickets/solicitudsOrganitzador/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${userLogged.getToken()}',
          },
          body: jsonEncode(body)
        );

        if (response.statusCode == 200) {
          print('Solicitud enviada exitosamente');
          return 200;
        } else {
          print('Error al enviar la solicitud: ${response.body}');
          return 500;
        }
      } catch (e) {
        print(e);
        return 500;
      }
  }

  List<Actividad> _convert_database_to_list(response) {
    List<Actividad> actividades = <Actividad>[];
    var actividadesJson = json.decode(response.body);

    if (actividadesJson is List) {
      actividadesJson.forEach((actividadJson) {
        Actividad actividad = Actividad();

        actividad.name = actividadJson['denominaci'];
        actividad.code = actividadJson['codi'];
        actividad.latitud = actividadJson['latitud'].toDouble();
        actividad.longitud = actividadJson['longitud'].toDouble();
        actividad.descripcio = actividadJson['descripcio'] ??
            'No hi ha cap descripció per aquesta activitat.';
        actividad.ubicacio = actividadJson['adre_a'] ?? 'No disponible';
        actividad.visualitzacions = actividadJson['visualitzacions'] ?? 0;
        actividad.categoria = actividadJson['tags_categor_es'] ?? '';

        actividad.imageUrl = actividadJson['imatges'] ?? '';

        String data = actividadJson['data_inici'] ?? '';
        actividad.dataInici = data.isNotEmpty ? data.substring(0, 10) : '-';
        if (actividad.dataInici == '9999-09-09')
          actividad.dataInici = 'Sense Data';

        data = actividadJson['data_fi'] ?? '';
        actividad.dataFi = data.isNotEmpty ? data.substring(0, 10) : '-';
        if (actividad.dataFi == '9999-09-09') actividad.dataFi = 'Sense Data';

        String url = actividadJson['enlla_os'] ?? '';
        if (url.isNotEmpty) {
          int endIndex = url.indexOf(',');
          actividad.urlEntrades =
              Uri.parse(endIndex != -1 ? url.substring(0, endIndex) : url);
        }

        String entrades = actividadJson['entrades'] ?? 'Veure més informació';
        if (entrades.isNotEmpty) {
          int endIndex = entrades.indexOf('€');
          actividad.preu =
              endIndex != -1 ? entrades.substring(0, endIndex) : entrades;
        }

        actividades.add(actividad);
      });
    }

    return actividades;
  }

  List<Usuario> _convert_database_to_list_user(response) {
    List<Usuario> usuarios = <Usuario>[];
    var usr = json.decode(response.body);

    if (usr is List) {
      usr.forEach((userJson) {
        Usuario usuario = Usuario();

        usuario.username = userJson['username'];
        usuario.favCats = userJson['favcategories'] ?? '';
        usuario.identificador = userJson['id'];
        
        usuarios.add(usuario);
      });
    }

    return usuarios;
  }

  List<Actividad> _convert_json_to_list(response) {
    var actividades = <Actividad>[];

    if (response.statusCode == 200) {
      var actividadesJson = json.decode(response.body);
      for (var actividadJson in actividadesJson) {
        var actividad = Actividad.fromJson(actividadJson);
        actividades.add(actividad);
      }
    }

    return actividades;
  }
  
  //foro existe? si no es asi crealo
  Future<Foro?> foroExists(String code) async {
    try {
      final respuesta = await http.get(Uri.parse('http://10.0.2.2:8080/foros/exists?activitat_code=$code'));

      if (respuesta.statusCode == 200) {
        final data = json.decode(respuesta.body);
        if (data['exists']) {
          //El foro existe, devuelve sus detalles
          return Foro(
            activitatCode: data['data']['activitat_code'],
            posts: data['data']['posts'] != null ? List<Post>.from(data['data']['posts'].map((post) => Post.fromJson(post))) : null,
          );
        } else {
          return null; //El foro no existe
        }
      } else {
        throw Exception('Fallo la obtención de datos: ${respuesta.statusCode}'); //Error en la solicitud HTTP
      }
    } catch (error) {
      throw Exception('Fallo la obtención de datos: $error'); //Error de red u otro tipo de error
    }
  }

  Future<bool> createForo(String code) async {
    try {
      final Map<String, dynamic> forodata = {
        'activitat_code': code,
      };

      final respuesta = await http.post(
        Uri.parse('http://10.0.2.2:8080/foros/create'),
        body: jsonEncode(forodata),
        headers: {'Content-Type': 'application/json'},
      );

      if (respuesta.statusCode == 201) {  
        print('Foro creado exitosamente');
        return true; 
      } else {
        print('Error al crear el foro: ${respuesta.statusCode}');
        return false; // Indica que ocurrió un error al crear el foro
      }
    } catch (error) {
      print('Error de red: $error');
      return false; // Indica que ocurrió un error al crear el foro
    }
  }

  //getPosts
  Future<List<Post>> getPostsForo(String foroId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Mapear los datos de los posts a una lista de objetos Post
        List<Post> posts = data.map((json) => Post.fromJson(json)).toList();
        posts.sort((a, b) => a.fecha.compareTo(b.fecha));
        return posts;
      } else if (response.statusCode == 404) {
        return []; // Devolver una lista vacía si no hay posts para este foro
      } else {
        throw Exception('Error al obtener los posts del foro: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  }
 
  //crear post
  Future<void> addPost(String foroId, String mensaje, String fecha, int numeroLikes) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'mensaje': mensaje,
          'fecha': fecha,
          'numero_likes': numeroLikes,
        }),
      );

      if (response.statusCode == 201) {
        print('Post agregado exitosamente al foro');
      } else {
        print('Error al agregar post al foro: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  //eliminar post
  Future<void> deletePost(String foroId, String? postId) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts/$postId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        print('Post eliminado exitosamente al foro');
      } else {
        print('Error al eliminar post del foro: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  //eliminar reply
  Future<void> deleteReply(String foroId, String? postId, String? replyId) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts/$postId/reply/$replyId');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        print('Reply eliminado exitosamente al foro');
      } else {
        print('Error al eliminar reply del foro: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  //crear reply
  Future<void> addReplyPost(String foroId, String postId, String mensaje, String fecha, int numeroLikes) async {
    try {
      final url = Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts/$postId/reply');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'mensaje': mensaje,
          'fecha': fecha,
          'numero_likes': numeroLikes,
        }),
      );

      if (response.statusCode == 201) {
        print('Reply agregada exitosamente al post');
      } else {
        print('Error al agregar reply al post: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud HTTP: $error');
    }
  }

  //getReplies
  Future<List<Post>> getReplyPosts(String foroId, String? postId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/foros/$foroId/posts/$postId/reply'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        //Mapear los datos de las replies a una lista de objetos Post
        List<Post> reply = data.map((json) => Post.fromJson(json)).toList();
        reply.sort((a, b) => a.fecha.compareTo(b.fecha));
        return reply;
      } else if (response.statusCode == 404) {
        return [];  //Devolver una lista vacía si no hay replies para este post
      } else {
        throw Exception('Error al obtener los replies del post: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error de red: $error');
    }
  } 

  //get de foroId
  Future<String?> getForoId(String activitatCode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('foros')
        .where('activitat_code', isEqualTo: activitatCode)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Devuelve el ID del primer documento con el código de actividad dado
    } else {
      return null; // Si no se encontró ningún documento con el código de actividad dado
    }
  }

  //modificar el como se encuentra el post, maybe añadir param que sea id = username + fecha
  Future<String?> getPostId(String foroId, String data) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('foros')
        .doc(foroId)
        .collection('posts')
        .where('fecha', isEqualTo: data)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; //Si se encuentra un doc con la misma fecha
    } else {
      return null; //Si no se encuentra ningún doc con la misma fecha
    }
  }

  //get reply Id
  Future<String?> getReplyId(String foroId, String? postId, String data) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('foros')
        .doc(foroId)
        .collection('posts')
        .doc(postId)
        .collection('reply')
        .where('fecha', isEqualTo: data)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; //Si se encuentra un doc con la misma fecha
    } else {
      return null; //Si no se encuentra ningún doc con la misma fecha
    }
  }
  
}

