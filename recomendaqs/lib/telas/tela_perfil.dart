import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
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

  void _exibirDialogoEditarNome() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String novoNome = nomeUsuario ?? '';
        return AlertDialog(
          title: Text('Editar Nome'),
          content: TextField(
            onChanged: (text) {
              novoNome = text;
            },
            decoration: InputDecoration(
              labelText: 'Novo Nome',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _atualizarNomeUsuario(novoNome);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _atualizarNomeUsuario(String novoNome) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(novoNome);
        _carregarDadosUsuario();
      }
    } catch (e) {
      print('Erro ao atualizar nome do usuário: $e');
    }
  }

  void _exibirDialogoConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text(
              'Tem certeza de que deseja excluir sua conta? Esta ação é irreversível.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _excluirConta();
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirConta() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      print('Erro ao excluir a conta: $e');
    }
  }

  void _sairDaConta() async {
    await _firebaseAuth.signOut();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nomeUsuario ?? 'Nome não definido',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _exibirDialogoEditarNome();
                  },
                ),
              ],
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
                  // Adicione a navegação para a tela de preferências
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sobre');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sobre o RecomendaQs'),
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
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/configuracoes_conta');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF1E1E1E),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Configurações da Conta'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Botão Excluir Conta
                  ElevatedButton(
                    onPressed: () {
                      _exibirDialogoConfirmacao();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Excluir Conta'),
                    ),
                  ),

                  // Botão Sair da Conta
                  ElevatedButton(
                    onPressed: () {
                      _sairDaConta();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Sair da Conta'),
                    ),
                  ),
                ],
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

  void _atualizarPagina(int index) {
    setState(() {
      paginaAtual = index;
    });

    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/pesquisa');
        break;
      case 2:
        Navigator.pushNamed(context, '/perfil');
        break;
      default:
        Navigator.pushNamed(context, '/inicial');
        break;
    }
  }
}
