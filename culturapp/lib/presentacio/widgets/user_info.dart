 import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/domain/models/usuari.dart';
import 'package:culturapp/presentacio/screens/vista_lista_actividades.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';

class UserInfoWidget extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Usuari user;
  final bool owner;
  final List<Actividad> activitatsVencidas;


  const UserInfoWidget({
    Key? key,
    required this.controladorPresentacion,
    required this.user,
    required this.owner,
    required this.activitatsVencidas
  }) : super(key: key);

  @override
  _UserInfoWidgetState createState() =>
      _UserInfoWidgetState(this.controladorPresentacion, this.user, this.activitatsVencidas, this.owner);
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  int _selectedIndex = 0;
  late ControladorPresentacion _controladorPresentacion;
  late Usuari _user;
  late List<Actividad> activitats;
  late List<Actividad> display_list;
  late bool show;
  late bool _owner;

  _UserInfoWidgetState(ControladorPresentacion controladorPresentacion, Usuari user, List<Actividad> activitatsVenc, bool owner) {
    _controladorPresentacion = controladorPresentacion;
    _user = user;
    activitats = [];
    display_list = [];
    show = false;
    _owner = owner;
  }

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() async {
    if (_owner) {
      _loadActividades(); 
      show = true;
    }
    else {
      bool isFriend = await _controladorPresentacion.isFriend(_user.nom);
      if (isFriend) {
        _loadActividades();
        show = true;
      }
      else {
        bool isPrivate = await _controladorPresentacion.checkPrivacy(_user.id);
        if (!isPrivate) {
          _loadActividades();
          show = true;
        }
      }
    }
  }

  void _loadActividades() async {
    activitats = await _controladorPresentacion.getActivitatsByUser(_user);
    print(activitats.toString());
    setState(() {
      display_list = activitats;
    });
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getLabelText(int index) {
    switch (index) {
      case 0:
        return 'Historico actividades';
      case 1:
        return 'Insignias o logros';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Actividad>>(
          future: Future.value(activitats),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Color(0xFFF4692A));
            } else if (snapshot.hasError) {
              return Text('Error al obtener el nombre de usuario');
            } else {
              final username = snapshot.data ?? '';
              return _buildUserInfo(_user, activitats);
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(Usuari _user, List<Actividad> activitats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 25, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(_user.image),
                radius: 50,
              ),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _user.nom,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '1500 XP',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 40,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(211, 211, 211, 0.5), // Fondo gris
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
                child: TextButton(
                  onPressed: () {
                    if (show) {
                      widget.controladorPresentacion.mostrarFollows(context, true);
                    }
                  },
                  child: Text(
                    "followers_and_following".tr(context),
                    style: TextStyle(
                      color: Color(0xFFF4692A), // Color del texto
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "assisted_events".tr(context)),
                    Tab(text: "badges".tr(context)),
                  ],
                  indicatorColor: const Color(0xFFF4692A),
                  labelColor: const Color(0xFFF4692A),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      if (show) 
                        Expanded(
                          child: ListView(
                            controller: ScrollController(),
                            children: [
                              SizedBox(
                                height: 450,
                                child: ListaActividadesDisponibles(
                                  actividades: display_list,
                                  controladorPresentacion: _controladorPresentacion,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                      Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: 50, color: Colors.grey),
                              SizedBox(height: 20,),
                              Text("private_account".tr(context), style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                      if (show)
                        const Text("Insignias")
                      else
                        Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock, size: 50, color: Colors.grey),
                                SizedBox(height: 20,),
                                Text("private_account".tr(context), style: TextStyle(fontSize: 24)),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
