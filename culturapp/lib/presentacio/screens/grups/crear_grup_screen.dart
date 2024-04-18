import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";

class CrearGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const CrearGrupScreen({Key? key, required this.controladorPresentacion})
      : super(key: key);

  @override
  State<CrearGrupScreen> createState() =>
      _CrearGrupScreen(this.controladorPresentacion);
}

class _CrearGrupScreen extends State<CrearGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  bool afegit = false;
  Color taronja_fluix = const Color.fromRGBO(240, 186, 132, 1);

  _CrearGrupScreen(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
  }

  static List<String> amics = [
    'user1',
    'user2',
    'user3',
    'user4',
    'user5',
    'user6',
    'user7',
    'user8',
    'user9',
    'user10',
    'user11',
  ];

  /*
  si es fes un model per els participants dels grups hauria de tindre els atributs següents:
  -nom
  -foto
  (aquests dos es podrien agafar dels usuaris)
  - bool de si han sigut afegits
  */

  List<String> participants = [
    'participant1',
    'participant2',
    'participant3',
    'participant4',
    'participant5',
    'participant6',
    'participant7',
    'participant8',
  ];

  void updateList(String value) {
    //funcio on es filtrarà la nostra llista
    setState(
      () {},
    );
  }

  void afegirParticipant(participant) {
    participants.add(participant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Crear Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'Escolleix els participants del nou grup: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
                _buildCercador(),
                const SizedBox(
                  height: 10.0,
                ),
                _buildAfegits(),
                Container(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 4),
                  height: 460.0,
                  child: ListView.builder(
                    itemCount: amics.length,
                    itemBuilder: (context, index) =>
                        _buildParticipant(context, index),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: _buildNextPageButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCercador() {
    return SizedBox(
        height: 40.0,
        width: 350.0,
        child: TextField(
          onChanged: (value) => updateList(value),
          cursorColor: Colors.white,
          cursorHeight: 20,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: taronja_fluix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: "Search...",
            hintStyle: const TextStyle(
              color: Colors.white,
            ),
            suffixIcon: const Icon(Icons.search),
            suffixIconColor: Colors.white,
          ),
        ));
  }

  Widget _buildAfegits() {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      alignment: Alignment.center,
      height: 75,
      width: 370,
      color: Colors.pink,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return _buildParticipantAfegit(context, index);
        },
      ),
    );
  }

  Widget _buildParticipantAfegit(context, index) {
    return Container(
      width: 80.0,
      height: 60.0,
      padding: const EdgeInsets.only(right: 1.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.network(
                'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
                fit: BoxFit.fill,
                width: 55.0,
                height: 55.0,
              ),
              //),
            ),
            Positioned(
              bottom: 9,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the radius as needed
                child: Container(
                  color: taronja_fluix.withOpacity(0.90),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    participants[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      //una vegada tingui mes info del model
      //dels perfils lo seu seria canviar-ho
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image.network(
        'https://w7.pngwing.com/pngs/635/97/png-transparent-computer-icons-the-broadleaf-group-people-icon-miscellaneous-monochrome-black.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50,
      ),
      title: Text(amics[index],
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          )),
      trailing: _buildBotoAfegir(amics[index]),
    );
  }

  Widget _buildBotoAfegir(participant) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        afegit = !afegit;
        afegirParticipant(participant);
      },
      child: Text(
        afegit ? '-' : '+',
      ),
    );
  } //com de moment no tinc l'estructura dels models
  //dels participant i això serà un atribut d'ells, no val la pena continuar de moment

  Widget _buildNextPageButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(240, 186, 132, 1),
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.arrow_forward),
      onPressed: () {
        _controladorPresentacion.mostrarConfigGrup(context);
      },
    );
  }
}
