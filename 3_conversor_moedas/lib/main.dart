// biblioteca para flutter funcionar
import 'package:flutter/material.dart';

// importar novas bibliotecas para trabalhar com api
import 'package:http/http.dart' as http;

// biblioteca para trabalhar com assincronos
import 'dart:async';

// biblioteca para trabalhar com json.
import 'dart:convert';

// constatnte que recebe valores da API passando minha chave
const request = "...";

void main() async {
  runApp(MaterialApp(
    // definir tema antes de chamar o home
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        )),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final reaisController = TextEditingController();
  final dolarsController = TextEditingController();
  final eurosController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    reaisController.text = "";
    dolarsController.text = "";
    eurosController.text = "";
  }

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarsController.text = (real / dolar).toStringAsFixed(3);
    eurosController.text = (real / euro).toStringAsFixed(3);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    reaisController.text = (dolar * this.dolar).toStringAsPrecision(3);
    eurosController.text = (dolar * this.dolar / euro).toStringAsFixed(3);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    reaisController.text = (euro * this.euro).toStringAsPrecision(3);
    dolarsController.text = (euro * this.euro / dolar).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" \$ Conversor \$"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      backgroundColor: Colors.black,
      // Future e para tomar ações numa linha de tempo neste caso api responder
      body: FutureBuilder<Map>(
          future: getData(),
          // expecificar o que mostrar na tela e, cada um dos casos
          builder: (context, snapshot) {
            // switch para ver o estatus da conexão
            switch (snapshot.connectionState) {
              // Se não estiver conectado ou alguardando uma conexão
              case ConnectionState.none:
              case ConnectionState.waiting:
                // ira retornar um widget abaixo
                return Center(
                  child: Text(
                    'Carregando dados',
                    style: TextStyle(color: Colors.amberAccent, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                );
              // caso tenha obtido alguma coisa retorna as opçoes abaixo
              default:
                if (snapshot.hasError) {
                  // se tiver erro
                  return Center(
                    child: Text(
                      'Erro ao carregar dados :(',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  );
                  // se não obtiver erro retorna abaixo
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amberAccent),
                        buildTextField(
                            "Reais", "R\$", reaisController, _realChange),
                        Divider(),
                        buildTextField(
                            "Dolars", "US\$", dolarsController, _dolarChange),
                        Divider(),
                        buildTextField(
                            "Euros", "€", eurosController, _euroChange),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController C, Function f) {
  return TextField(
    controller: C,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixText: prefix,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
          fontSize: 20,
        )),
    style: TextStyle(color: Colors.amber, fontSize: 30),
    keyboardType: TextInputType.number,
    onChanged: f,
  );
}

//usando Future, async e await para pegar dados da API
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);

  // exemplo abaixo decodificando o json e acessando apenas o result
  //print( jsonDecode(response.body)["results"]["currencies"]["EUR"]);
}
