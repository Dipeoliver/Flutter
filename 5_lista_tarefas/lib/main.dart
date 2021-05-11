import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

//importar biblioteca para gravar e ler arquivos do android
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // criar uma lista
  final _toDoController = TextEditingController();
  List _toDoList = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // mapa para remover sempre a ultima posição
  Map<String, dynamic> _lastRemoved;

// verificar qual posicao foi removida
  int _lastRemovedPos;

  // chamar um metodo sempre que inicamos nossa aplicação Crtl + o
  @override
  void initState() {
    super.initState();
    // vamos requisitar os dados atraves do _readData(),
    // e assim que retornar, recebemos os valores data
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      // quando trabalhar com json usar
      Map<String, dynamic> newToDO = Map();
      newToDO["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDO["ok"] = false;
      _toDoList.add(newToDO);
      // fazer a chamada para salvar
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    // dar um delay na aplicação, quando for chamada para banco nao usar
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // função tera dois argumentos (a,b)
      // tem de retornar:
      // numero positivo se a > b
      // zero se a == b
      // numero negativo se a < b

      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List to Do'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: 'New job',
                      labelStyle: TextStyle(
                        color: Colors.purple,
                        fontSize: 10,
                      ),
                    ),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        print(value);
                        return 'Campo Obrigatório em Branco';
                      }
                      return null;
                    },
                  )),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _addToDo();
                      }
                    },
                    child: Text(
                      'ADD',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple, onPrimary: Colors.white),
                  ),
                ],
              ),
            ),
            // constroi a lista conforme for mostrando na tela

            Expanded(
              // RefreshIndicator ira atualizar a lista colocando os
              // itens nao feitos acima
              child: RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: _toDoList.length, // pegar tamanho da lista
                    itemBuilder: buildItem),
                // chama a funcao que ira atualizar
                onRefresh: _refresh,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    // Dismissible e quem permite deletar itens
    return Dismissible(
      // pode udar um valor aleatório abaixo, usamos tempo
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        // Align para alinhar a esquerda o icone
        child: Align(
          // tenho passar valor que varia  ( -1 0 1) posição icone
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      // da esqueda para a direita
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        //checkboxListTile -> é uma lista com checkbox
        // estrutura  Text(_toDoList[index]["title"], irá me
        // retornar uma string relacionada ao numero do index
        // a lista _toDoList
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            // salvar a atualização
            _saveData();
          });
        },
      ),
      // sempre que deslizar para o lado faz algo dependendo do lado tem função diferente
      onDismissed: (direction) {
        // quando for remover um item duplica ele colocando na ultima posição
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]); // item que foi removido
          _lastRemovedPos = index; // index do item que foi removido
          _toDoList.removeAt(index); // remoção do item

          _saveData();
          // apos apagar irei mostar um snackbar.
          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            // ação que ira fazer ao clicar no snackBar ao desfazer
            action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                  setState(() {
                    // volta o item na posição que foi removido (index, item)
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            // tempo que ira exibir o snack
            duration: Duration(seconds: 3),
          );
          // exibir o snackBar
          ScaffoldMessenger.of(context).showSnackBar(snack);
        });
      },
    );
  }

  // criar uma função que ira acessar e retonar o arquivo que eu irei utilizar.
  Future<File> _getFile() async {
    // acessa o diretorio onde vamos armazenar (diferente entre android e IOS)
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  // Save File
  Future<File> _saveData() async {
    String data = json.encode(_toDoList); // take list and convert in json
    final file = await _getFile(); // open local file
    return file.writeAsString(data); // record file
  }

  // Read File
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
