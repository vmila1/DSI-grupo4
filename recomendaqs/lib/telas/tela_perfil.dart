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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              'Nome do Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Configurações de HQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/favoritos');
                },
                child: Text('Favoritos'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Adicione aqui a lógica para navegar para a tela de Preferências
                },
                child: Text('Preferências'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lido');
                },
                child: Text('HQs Lidos'),
              ),
            ),
            SizedBox(height: 20),
            // Espaço entre o botão "HQs Lidos" e o título "Configurações da Conta"
            Text(
              'Configurações da Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Título para alterar e-mail
            Text(
              'Alterar E-mail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      labelText: 'Alterar E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Título para alterar senha
            Text(
              'Alterar Senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      labelText: 'Alterar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Título para confirmar senha
            Text(
              'Confirmar Senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Caixa de texto para confirmar senha
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    obscureText: true,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Botão "Sair" com cor vermelha
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Cor vermelha
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
            // Botões de navegação
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
                height:
                    20), // Espaçamento adicional entre os botões e a borda inferior
          ],
        ),
      ),
    );
  }
}
