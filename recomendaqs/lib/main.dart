import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_favoritos.dart';
import 'package:recomendaqs/telas/tela_lidos.dart';
import 'package:recomendaqs/telas/tela_login.dart';
import 'package:recomendaqs/telas/tela_cadastro.dart';
import 'package:recomendaqs/telas/teste_tela.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/lido': (context) => TelaLidos(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/inicial': (context) => HomePage(),
      },
    );
  }
}
