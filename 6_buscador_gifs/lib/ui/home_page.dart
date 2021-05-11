import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  // buscar gif por API (nao é isntantaneo no futuro)
  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null)
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=CoN4HFI3ByJW9QliOGOvhDxfQkbeBDQ8&limit=25&rating=g');
    else
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=CoN4HFI3ByJW9QliOGOvhDxfQkbeBDQ8&q=$_search=$_offset=0&rating=g&lang=pt');
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.network(
              'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder()),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            // Expanded para pegar o resto da tela total
            Expanded(
                child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    // ira olhar o sattus da conexao do snapshot
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 600,
                          height: 600,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            strokeWidth: 8, // ** tamanho da animação
                          ),
                        );
                      default:
                        if (snapshot.hasError) return Container();
                        else return _createGifTable(context, snapshot);
                    }
                  },
                ))
          ],
        ));
  }
}

Widget _createGifTable( BuildContext context, AsyncSnapshot snapshot){

}