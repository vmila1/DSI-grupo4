import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nomeUsuario = "";
  String imagemUsuario = "assets/images/icone_perfil.jpg";
  int paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          nomeUsuario = user.displayName ?? "Nome Padrão";
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text(
          'Olá, $nomeUsuario',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/perfil');
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage(imagemUsuario),
                radius: 30,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'HQs Favoritas:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListaHQsFavoritasFirestore(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recomendações:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListaRecomendacoesFirestore(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Populares no momento:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListaPopularesFirestore(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Lançamentos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListaLancamentosFirestore(),
              ],
            ),
          ),
        ],
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
        break;
    }
  }
}

class ListaHQsFavoritasFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('HQs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var hqs = snapshot.data!.docs;

          List<Widget> hqWidgets = [];
          for (var hq in hqs) {
            var hqData = hq.data() as Map<String, dynamic>;
            var imagemHQ = hqData['imagem'];
            var nomeDocumento = hq.id; // Obtemos o nome do documento

            if (imagemHQ != null) {
              hqWidgets.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HqPage(
                          hqDocumentName: nomeDocumento,
                          imagemHQ: '',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imagemHQ,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: 115,
                    ),
                  ),
                ),
              );
            }
          }

          return ListView(
            scrollDirection: Axis.horizontal,
            children: hqWidgets,
          );
        },
      ),
    );
  }
}

class ListaRecomendacoesFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('HQs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var recomendacoes = snapshot.data!.docs
              .map(
                (hq) => hq.data() as Map<String, dynamic>,
              )
              .where(
                (hqData) => hqData['imagem'] != null,
              )
              .map(
                (hqData) => hqData['imagem'] as String,
              )
              .toList();

          // Embaralhar a lista de recomendações aleatoriamente
          recomendacoes.shuffle();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recomendacoes.length,
            itemBuilder: (BuildContext context, int index) {
              var nomeDocumento = snapshot.data!.docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HqPage(
                        hqDocumentName: nomeDocumento,
                        imagemHQ: '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    recomendacoes[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: 115,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ListaPopularesFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('HQs').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var populares = snapshot.data!.docs
              .map(
                (hq) => hq.data() as Map<String, dynamic>,
              )
              .where(
                (hqData) => hqData['imagem'] != null,
              )
              .map(
                (hqData) => hqData['imagem'] as String,
              )
              .toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: populares.length,
            itemBuilder: (BuildContext context, int index) {
              var nomeDocumento = snapshot.data!.docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HqPage(
                        hqDocumentName: nomeDocumento,
                        imagemHQ: '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    populares[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: 115,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ListaLancamentosFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('HQs')
            .orderBy('anolançamento',
                descending: true) // Adicionado ordenação por ano de lançamento
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          var lancamentos = snapshot.data!.docs
              .map(
                (hq) => hq.data() as Map<String, dynamic>,
              )
              .where(
                (hqData) => hqData['imagem'] != null,
              )
              .map(
                (hqData) => hqData['imagem'] as String,
              )
              .toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lancamentos.length,
            itemBuilder: (BuildContext context, int index) {
              var nomeDocumento = snapshot.data!.docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HqPage(
                        hqDocumentName: nomeDocumento,
                        imagemHQ: '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    lancamentos[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: 115,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
