import "dart:convert";
import "package:culturapp/presentacio/controlador_presentacio.dart";
import 'package:http/http.dart' as http;
import "package:culturapp/domain/models/filtre_data.dart";
import "package:culturapp/domain/models/actividad.dart";
import "package:culturapp/domain/models/filtre_categoria.dart";
import "package:flutter/material.dart";

class SearchMyActivities extends StatefulWidget {
  final ControladorPresentacion controladorPresentacion;

  const SearchMyActivities(Key? key, this.controladorPresentacion);

  @override
  State<SearchMyActivities> createState() =>
      _SearchMyActivitiesState(controladorPresentacion);
}

class _SearchMyActivitiesState extends State<SearchMyActivities> {
  late ControladorPresentacion _controladorPresentacion;

  _SearchMyActivitiesState(ControladorPresentacion controladorPresentacion) {
    _controladorPresentacion = controladorPresentacion;
    selectedCategoria = '';
    selectedData = '';
    squery = '';
    llista = [];
  }

  late String selectedCategoria;
  late String selectedData;
  late String squery;
  late List<Actividad> llista;

  Future<void> searchActivitat(
      String searchQuery, String categoria, String data) async {
    llista = (await _controladorPresentacion.searchActivitatAmbFiltres(
        searchQuery, categoria, data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Search for an event",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(240, 186, 132, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search...",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchActivitat(
                              squery, selectedCategoria, selectedData);
                        },
                        icon: Icon(Icons.search),
                      ),
                      suffixIconColor: Colors.white,
                    ),
                    onChanged: (value) {
                      squery = value;
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                Row(children: [
                  SizedBox(
                    height: 30.0,
                    width: 100.0,
                    child: FiltreCategoria(canviCategoria: (newCategoria) {
                      setState(() {
                        selectedCategoria = newCategoria!;
                      });
                    }),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 150.0,
                    child: FiltreData(canviData: (newData) {
                      setState(() {
                        selectedData = newData!;
                      });
                    }),
                  )
                ]),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: llista.length,
                      itemBuilder: (context, index) => ListTile(
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Text(llista[index].name,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(llista[index].categoria as String,
                                style: const TextStyle(color: Colors.orange)),
                            trailing: Text("${llista[index].preu}",
                                style: TextStyle(color: Colors.orange)),
                            leading: Image.network(llista[index].imageUrl!),
                          )),
                ),
              ]),
        ));
  }
}
