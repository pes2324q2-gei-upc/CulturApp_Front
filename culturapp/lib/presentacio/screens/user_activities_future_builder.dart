
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/screens/vista_mis_actividades.dart';
import 'package:flutter/material.dart';

class UserActivitiesFutureBuilder extends StatelessWidget {
  final String userId;
  final ControladorPresentacion cp;

  const UserActivitiesFutureBuilder({super.key, required this.userId, required this.cp});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cp.getUserActivities(userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // While the future is not resolved
        if (snapshot.connectionState != ConnectionState.done) {
          // Return loading screen
          return Column(
            children: [
              Row(children: [Text('No data, the user name is: $userId')]),
              Row(children: [const CircularProgressIndicator()],)
            ],
          );
        }

        // Once the future is resolved
        if (snapshot.hasData) {
          // Navigate to ListaMisActividades
          return ListaMisActividades(
            actividades: snapshot.data,
          );
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}, the user name is: $userId');
        } else {
          // Handle no data case
          return Text('No data, the user name is: $userId');
        }
      },
    );
  }
}
