# contador_de_pessoas

Neste projeto foi ensinado:

- adicionar imagem
Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),

- Adicinar colunas
Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[]

- Adicionar Texto
Text(
              'Pessoas: $_people',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
- Adicionar linhas
Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[]

- Adicionar espaçamento
 Padding(
                  padding: EdgeInsets.all(10),
                  child:
- Adicionar botão
TextButton(
                      onPressed: () {
                        _changePeople(1);
                        debugPrint("+1");
                        print("12");
                      },
                      child: Text(
                        '+1',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )),
-


