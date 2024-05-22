import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/user_box.dart';

class LlistarBlocked extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  const LlistarBlocked({super.key, required this.controladorPresentacion});

  @override
  _LlistarBlockedState createState() => _LlistarBlockedState();
}

class _LlistarBlockedState extends State<LlistarBlocked> {
  late List<String> users;
  bool _isLoading = false;

  List<String> originalUsers = [];
  
  void updateList(String value) {
    setState(() {
      if (originalUsers.isEmpty) {
        originalUsers = List.from(users);
      }
      users = originalUsers.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  Future<void> updateUsers() async {
    setState(() {
      _isLoading = true;
    });
    final blocked = widget.controladorPresentacion.getBlockedUsers();
    setState(() {
      users = blocked;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updateUsers();
  }

  @override
   @override
  Widget build(BuildContext context) {
    return _isLoading
      ? const Center(child: CircularProgressIndicator(color: Color(0xFFF4692A), backgroundColor: Colors.white,)
      ) : Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text("Usuarios bloqeuados"),
        centerTitle: true, // Centrar el título
        toolbarHeight: 50.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 26.0), 
          SizedBox(
            height: 45.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'search'.tr(context),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    updateList(value);
                  },
                ),
              ),
            ),
            ),
          ),
          const SizedBox(height: 5.0), 
          Expanded(
            child: RefreshIndicator(
              onRefresh: updateUsers,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      userBox(
                        text: users[index], 
                        recomm: false, 
                        type: "reportUserBlocked", 
                        popUpStyle: "default",
                        placeReport: "null",
                        controladorPresentacion: widget.controladorPresentacion),
                      const SizedBox(height: 5.0), 
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
