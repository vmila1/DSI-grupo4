import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_favoritos.dart' as Favorito;
import 'package:recomendaqs/telas/tela_lidos.dart';
import 'package:recomendaqs/telas/tela_login.dart';
import 'package:recomendaqs/telas/tela_cadastro.dart';
import 'package:recomendaqs/telas/tela_inicial.dart';
import 'package:recomendaqs/telas/tela_perfil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/perfil',
      routes: {
        '/lido': (context) => TelaLidos(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/inicial': (context) => HomePage(),
        '/perfil': (context) => TelaPerfil(),
        '/favoritos': (context) => Favorito.TelaFavoritos()
      },
    );
  }
}
