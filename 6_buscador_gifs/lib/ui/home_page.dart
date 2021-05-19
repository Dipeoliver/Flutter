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

  // buscar gif por API (nao é isntantaneo, é no futuro)
  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null || _search == '')
      response = await http.get(
          'https://api.giphy.com/v1/gifs/trending?api_key=CoN4HFI3ByJW9QliOGOvhDxfQkbeBDQ8&limit=25&rating=g');
    else
      response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=CoN4HFI3ByJW9QliOGOvhDxfQkbeBDQ8&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt');

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
              onFieldSubmitted: (text){
                setState(() { // ** ao pesquisar atualizo a tela
                  _search = text; // ** passo o valor digitado para a função
                  _offset = 0;
                });
              },
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 8, // ** tamanho da animação
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }
  // ** se estiver pesquisando quero deixar espaço no final
  int _getCount(List data){
    if (_search == null){
      return data.length;
    }
    else
      {
        return data.length + 1; // ** '+ 1 pq em na url so tem 19'
      }
  }


  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        // ** created a grid in screen
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data["data"]), // passando tamanho
        itemBuilder: (context, index){
          // ** se nao estiver pesquisando retorna abaixo
          if(_search == null || index < snapshot.data["data"].length)
            return GestureDetector( //** detect screen touch
              
              child: Column(
                children: [
                  Image.network(snapshot.data["data"][index]["images"]["fixed_height"]["url"], height:150, fit: BoxFit.cover),
                  Text(snapshot.data["data"][index]["title"], style: TextStyle(color: Colors.white, fontSize: 5),)
                ],
              )
              
            );
          else
            // se estiver pesquisando retorna botão para aparecer mais gis
            
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color : Colors.white,size: 70,),
                    Text("Carregar mais...", style: TextStyle(color:Colors.white, fontSize: 22),)

                  ],
                ),
                onTap: (){   // ** ao clicar no '+' ira carregar mais 19 na tela
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
        }
    );
  }
}


