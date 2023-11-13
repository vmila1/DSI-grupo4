import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_lidos.dart';
import 'package:recomendaqs/telas/tela_favoritos.dart';
import 'package:recomendaqs/telas/tela_login.dart';

class TelaPerfil extends StatefulWidget {
  @override
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  String senha = '';
  String imagemUsuario = "assets/images/icone_perfil.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // Cor de fundo desejada
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagemUsuario),
            ),
            SizedBox(height: 10),
            Text(
              'Leon Lourenço',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Cor do texto branca
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Configurações de HQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/favoritos');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1E1E1E),
                  onPrimary: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Favoritos'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Adicione aqui a lógica para navegar para a tela de Preferências
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1E1E1E),
                  onPrimary: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Preferências'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lido');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1E1E1E),
                  onPrimary: Colors.white,
                  side: BorderSide(color: Colors.white),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('HQs Lidos'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Configurações da Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left, // Alinhamento à esquerda
            ),
            SizedBox(height: 10),
            Text(
              'Alterar E-mail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Caixa de texto para alterar e-mail
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      // Adicione aqui a lógica para lidar com a alteração do e-mail
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Alterar E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Alterar Senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Caixa de texto para alterar senha
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      senha = text;
                    },
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Alterar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Confirmar Senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Caixa de texto para confirmar senha
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Sair'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inicial');
                    },
                    icon: Icon(Icons.home),
                    label: Text('Início'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Adicione aqui a lógica para navegar para a tela de Buscar
                    },
                    icon: Icon(Icons.search),
                    label: Text('Buscar'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Adicione aqui a lógica para navegar para a tela de Perfil
                    },
                    icon: Icon(Icons.person),
                    label: Text('Perfil'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
