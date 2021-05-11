import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  // declarar objetos para pegar valore
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  // para trabalhar com validacao de forms
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // declarar variavel texto
  String _info = 'Informe seus dados';

  void _resetFields() {
    weightController.text = '';
    heightController.text = '';
    setState(() {
      _info = 'Informe seus dados';
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    // atualizar a tela chamar o setStat()
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;

      double imc = weight / (height * height);
      debugPrint(imc.toStringAsPrecision(3));
      if (imc < 18.5) {
        _info = 'Abaixo do peso: (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 18.5 && imc < 24.9) {
        _info = 'Peso Ideal: (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _info = 'SOBREPESO: (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 30 && imc < 39.9) {
        _info = 'Obesidade Grau II: (${imc.toStringAsPrecision(3)})';
      } else if (imc >= 40) {
        _info = 'Obesidade Grau III: (${imc.toStringAsPrecision(3)})';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("IMC CALC"),
          centerTitle: true,
          backgroundColor: Colors.limeAccent ,
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
          ],
        ),
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          // para pode rolar a visualização
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.person_outline_outlined,
                        size: 120, color: Colors.pinkAccent),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Peso (Kg)',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 30,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 25),
                    controller: weightController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu peso!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Altura (cm)',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 30,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 25),
                    controller: heightController,
                    validator: (value) {
                      // fazer varios tipos de validação
                      if (value.isEmpty) {
                        return "Insira sua Altura";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: (){
                          if (_formKey.currentState.validate()){
                            _calculate();
                          }
                        },
                        child: Text(
                          'Calcular',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent, // background
                          onPrimary: Colors.white, // foreground
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(_info,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.pinkAccent, fontSize: 25)),
                  )
                ]),
          ),
        ));
  }
}
