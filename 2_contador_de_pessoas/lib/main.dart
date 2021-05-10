import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(title: 'Contador de Pessoas', home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
// variavel acessivel somente dentro dessa classe
  int _people = 0;
  String info = "Pode Entrar";

  // faz a tela atualizar somente onde precisa
  void _changePeople(int delta) {
    setState(() {
      if (_people >= 0 && _people <= 10 && delta == 1) {
        _people += delta;
      } else if (_people == 10 && delta == 1) {
        //
      } else if (_people == 10 && delta == -1) {
        _people += delta;
      } else if (_people == 0 && delta == -1) {
        //
      } else {
        _people += delta;
      }

      if (_people >= 10) {
        info = "Lotação Maxima";
      } else {
        info = "Pode Entrar";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pessoas: $_people',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                      onPressed: () {
                        _changePeople(1);
                        debugPrint("+1");
                        print("12");
                      },
                      child: Text(
                        '+1',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton(
                      onPressed: () {
                        _changePeople(-1);
                        debugPrint("-1");
                      },
                      child: Text(
                        '-1',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )),
                ),
              ],
            ),
            Text(
              info,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30),
            )
          ],
        ),
      ],
    );
  }
}
