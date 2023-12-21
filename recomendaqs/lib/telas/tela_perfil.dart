import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaPerfilState createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  String senha = '';
  String? nomeUsuario = "";
  String imagemUsuario = "assets/images/icone_perfil.jpg";
  int paginaAtual = 2;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  // Função para carregar os dados do usuário
  Future<void> _carregarDadosUsuario() async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        setState(() {
          nomeUsuario = user.displayName;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Cor de fundo
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imagemUsuario),
            ),

            const SizedBox(height: 10),
            Text(
              nomeUsuario ?? 'Nome não definido',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Cor do texto
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Configurações de HQs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Script",
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/favoritos');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Favoritos'),
                ),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Falta a aba de preferências
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Preferências'),
                ),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lido');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('HQs Lidos'),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Configurações da Conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left, // Alinhamento à esquerda
            ),

            const SizedBox(height: 10),
            const Text(
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
                      // Falta a logica de alterar email
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Alterar E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Alterar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Text(
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      labelStyle: const TextStyle(color: Colors.white),
                      fillColor: const Color(0xFF6F6F6F),
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Sair'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        currentIndex: paginaAtual,
        onTap: _atualizarPagina,
      ),
    );
  }

  // Função para atualizar a página conforme a navegação
  void _atualizarPagina(int index) {
    setState(() {
      paginaAtual = index;
    });

    switch (index) {
      case 1:
        // Tela de Busca (falta implementar essa aba)
        Navigator.pushNamed(context, '/pesquisa');
        break;
      case 2:
        // Tela de Perfil
        Navigator.pushNamed(context, '/perfil');
        break;
      default:
        // Tela Inicial
        Navigator.pushNamed(context, '/inicial');
        break;
    }
  }
}
