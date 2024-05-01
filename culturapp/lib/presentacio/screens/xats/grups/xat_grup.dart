import "package:culturapp/domain/models/grup.dart";
import "package:culturapp/domain/models/message.dart";
import "package:culturapp/domain/models/usuari.dart";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import "package:culturapp/presentacio/widgets/chat_bubble.dart";
import "package:flutter/material.dart";

class XatGrupScreen extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;
  final Grup grup;

  const XatGrupScreen(
      {Key? key, required this.controladorPresentacion, required this.grup})
      : super(key: key);

  @override
  State<XatGrupScreen> createState() =>
      _XatGrupScreen(this.controladorPresentacion, this.grup);
}

class _XatGrupScreen extends State<XatGrupScreen> {
  late ControladorPresentacion _controladorPresentacion;
  late Grup _grup;
  late Future<List<String>> nomParticipants;
  late List<Message> missatges;

  Color taronjaFluix = const Color.fromRGBO(240, 186, 132, 1);
  Color grisFluix = const Color.fromRGBO(211, 211, 211, 0.5);

  _XatGrupScreen(ControladorPresentacion controladorPresentacion, Grup grup) {
    _controladorPresentacion = controladorPresentacion;
    _grup = grup;
    nomParticipants = agafarNomsParticipants(_grup.membres);
    missatges = [];
    //missatges = _grup.missatgesGrup;
  }

  Future<List<String>> agafarNomsParticipants(
      List<dynamic> participants) async {
    List<String> nomParticipants = [];

    for (int i = 0; i < participants.length; ++i) {
      //print(participants[i]);
      //s'haurien de conseguir el noms del users
      //String name = await _controladorPresentacion.getUsername(participants[i]);
      //nomParticipants.add(name);
    }

    return nomParticipants;
  }

  String truncarString(String noms, int maxLength) {
    if (noms.length <= maxLength) {
      return noms; // Return the original string if it's not longer than maxLength
    } else {
      return '${noms.substring(0, maxLength - 3)}...'; // Truncate and add '...'
    }
  }

  final TextEditingController _controller = TextEditingController();

  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      missatges.insert(
        0,
        Message(text: text, sender: 'Me', timeSended: "10:00"),
      );
      //crida al backend per penjar missatge al grup
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: grisFluix,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: missatges.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(missatges[index]);
                },
              ),
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _bottomInputField(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () => _controladorPresentacion.mostrarXats(context),
      ),
      title: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/userImage.png'),
            //AssetImage(_grup.imageGroup),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _grup.nomGroup,
                style: const TextStyle(color: Colors.white),
              ),
              //el join no le gusta
              /*
              Text(
                truncarString(nomParticipants.join(', '), 35),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
              */
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {
            _controladorPresentacion.mostrarInfoGrup(context, _grup);
          },
        ),
      ],
    );
  }

  Widget _buildChatBubble(message) {
    return ChatBubble(
      userName: message.sender,
      message: message.text,
      time: message.timeSended,
    );
  }

  Widget _bottomInputField() {
    return IconTheme(
      data: const IconThemeData(color: Colors.orange),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}
