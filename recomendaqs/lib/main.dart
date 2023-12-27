import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_favoritos.dart';
import 'package:recomendaqs/telas/tela_lidos.dart';
import 'package:recomendaqs/telas/tela_login.dart';
import 'package:recomendaqs/telas/tela_cadastro.dart';
import 'package:recomendaqs/telas/tela_inicial.dart';
import 'package:recomendaqs/telas/tela_perfil.dart';
import 'package:recomendaqs/telas/tela_hq.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recomendaqs/telas/tela_pesquisa.dart';
import 'package:recomendaqs/telas/tela_sobre.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/inicial': (context) => const HomePage(),
        '/lido': (context) => const LidoPage(),
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/perfil': (context) => const TelaPerfil(),
        '/favoritos': (context) => const FavoritoPage(),
        '/hq': (context) => const HqPage(),
        '/pesquisa': (context) => const TelaPesquisa(),
        '/sobre': (context) => const TelaSobre(),
      },
    );
  }
}
