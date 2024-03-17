import "package:culturapp/presentacio/routes/routes.dart";
import "package:culturapp/presentacio/screens/amics.dart";
import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";

class Xats extends StatefulWidget {
  const Xats({super.key});

  @override
  State<Xats> createState() => _Xats();
}

class _Xats extends State<Xats> {
  //List<Actividad> activitats = null; quan tinguem de base de dades fer-ho bé
  Widget currentContent = Amics();

  void changeContent(Widget newContent) {
    setState(() {
      currentContent = newContent;
    });
  }

  void _onTabChange(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, Routes.misActividades);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.xats);
        break;
      case 3:
        Navigator.pushNamed(context, Routes.perfil);
        break;
      default:
        break;
    }
  }

  Color _buttonAmics = Colors.grey;
  Color _buttonGrups = Colors.orange;
  Color _buttonAfegirAmics = Colors.orange;

  void _changeButtonColor(int buttonNumber) {
    setState(() {
      if (buttonNumber == 1) {
        _buttonAmics = Colors.grey;
        _buttonGrups = Colors.orange;
        _buttonAfegirAmics = Colors.orange;
      } else if (buttonNumber == 2) {
        _buttonAmics = Colors.orange;
        _buttonGrups = Colors.grey;
        _buttonAfegirAmics = Colors.orange;
      } else if (buttonNumber == 3) {
        _buttonAmics = Colors.orange;
        _buttonGrups = Colors.orange;
        _buttonAfegirAmics = Colors.grey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        title: const Text(
          'Xats',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 50.0,
                        width: 120.0,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(_buttonAmics),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            _changeButtonColor(1);
                            changeContent(Amics());
                          },
                          child: Text('Amics'),
                        )),
                    SizedBox(
                        height: 50.0,
                        width: 120.0,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(_buttonGrups),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            _changeButtonColor(2);
                            changeContent(Grups());
                          },
                          child: Text('Grups'),
                        )),
                    SizedBox(
                        height: 50.0,
                        width: 120.0,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                _buttonAfegirAmics),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            _changeButtonColor(3);
                            changeContent(AfegirAmics());
                          },
                          child: Text('Afegir Amics'),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: currentContent,
                ),
              ]),
        ),
      ),
      //container amb les diferents pantalles
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        ),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.orange,
          activeColor: Colors.orange,
          tabBackgroundColor: Colors.grey.shade100,
          gap: 6,
          onTabChange: (index) {
            _onTabChange(index);
          },
          selectedIndex: 3,
          tabs: const [
            GButton(
                text: "Mapa",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.map),
            GButton(
                text: "Mis Actividades",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.event),
            GButton(
                text: "Chats",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.chat),
            GButton(
                text: "Perfil",
                textStyle: TextStyle(fontSize: 12, color: Colors.orange),
                icon: Icons.person),
          ],
        ),
      ),
    );
  }
}

class Grups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('This is Grups');
  }
}

class AfegirAmics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('This is AfegirAmics');
  }
}