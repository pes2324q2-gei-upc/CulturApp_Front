import "dart:typed_data";

import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class ConfigGrup extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final List<Usuari> participants;

  const ConfigGrup(
      {Key? key,
      required this.controladorPresentacion,
      required this.participants})
      : super(key: key);

  @override
  State<ConfigGrup> createState() =>
      _ConfigGrup(this.controladorPresentacion, this.participants);
}

class _ConfigGrup extends State<ConfigGrup> {
  late ControladorPresentacion _controladorPresentacion;

  double llargadaPantalla = 440;
  double llargadaPantallaTitols = 438;
  bool afegit = false;

  String nomGrup = 'nomDefault';
  String descripcioGrup = '';
  String imatgeGrup = 'assets/userImage.png';
  List<String> membres = [];
  List<Usuari> _participants = [];

  Uint8List? _image;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);

  _ConfigGrup(ControladorPresentacion controladorPresentacion,
      List<Usuari> participants) {
    _controladorPresentacion = controladorPresentacion;
    _participants = participants;
  }

  void assignarImatge() async {
    //de moment no funcional
    //imatgeGrup = value;

    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if(_file != null) {
      return await _file.readAsBytes();
    }
  }

  void crearGrup() {
    //imatge hardcoded de moment
    for (Usuari usuari in _participants) {
      membres.add(usuari.nom);
    }

    //cridar a funcio del back de crear el grup, passant com a parametre la variable nouGrup
    _controladorPresentacion.createGrup(
        nomGrup, descripcioGrup, _image, membres);
    _controladorPresentacion.mostrarXats(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4692A),
        title: const Text(
          'Configuració Grup',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildEscollirImatge(),
                      const SizedBox(
                        width: 10,
                      ),
                      _buildInsertarNom(),
                    ],
                  ),
                  Column(
                    children: [
                      _buildInsertarDescripcio(),
                      _buildLlistarParticipants(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: _buildCrearGrupButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEscollirImatge() {
    return Column(
      children: [
        const Text(
          'Imatge (opt):',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Stack (
            children: [
              _image != null ? 
                CircleAvatar(
                  backgroundImage: MemoryImage(_image!),
                  radius: 65,
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage('assets/userImage.png'),
                  radius: 65,
                ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: assignarImatge,
                  icon: const Icon(Icons.add_a_photo),
                )
              )
            ],
          )
        ),
      ],
    );
  }

  Widget _buildInsertarNom() {
    return Column(
      children: [
        Container(
          width: 238,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nom:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SizedBox(
          width: 240,
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: TextField(
              cursorColor: Colors.white,
              cursorHeight: 20,
              onChanged: (value) {
                setState(() {
                  nomGrup = value;
                });
              },
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Nom del grup...',
                hintStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsertarDescripcio() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0),
          width: llargadaPantallaTitols,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Descripció:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Container(
          width: llargadaPantalla,
          height: 155,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5),
          child: TextField(
            maxLines: 6,
            cursorColor: Colors.white,
            cursorHeight: 20,
            onChanged: (value) {
              setState(() {
                descripcioGrup = value;
              });
            },
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Descripció del grup...',
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLlistarParticipants() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          width: llargadaPantallaTitols,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Participants:',
            selectionColor: Colors.blue,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        SizedBox(
          height: 300,
          width: llargadaPantalla,
          child: ListView.builder(
            itemCount: _participants.length,
            itemBuilder: (context, index) => _buildParticipant(context, index),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipant(context, index) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: Image(
        image: AssetImage(_participants[index].image),
        fit: BoxFit.fill,
        width: 50.0,
        height: 50.0,
      ),
      title: Text(_participants[index].nom,
          style: const TextStyle(
            color: Color(0xFFF4692A),
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _buildCrearGrupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: taronjaFluix,
        foregroundColor: Colors.white,
      ),
      child: const Icon(Icons.check),
      onPressed: () {
        crearGrup();
      },
    );
  }
}
