import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:culturapp/routes/routes.dart';
import 'package:culturapp/pages/login.dart';

class Logout extends StatelessWidget {
  
  User? _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Logout(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userInfo(context)
      );
  }

  Widget _userInfo(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(_user!.photoURL!)))
        ),
        Text(_user!.email!),
        Text(_user!.displayName ?? ""),
        MaterialButton(
          color: Colors.red,
          child: const Text("Sign out"),
          onPressed: () => signout(context))
        ],
      ),
    );
  }

  void signout(context) {
    _auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    ); // Cierra la llamada a MaterialPageRoute
  }
}
