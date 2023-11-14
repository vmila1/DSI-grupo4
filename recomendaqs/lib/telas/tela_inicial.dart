// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nomeUsuario = "Leon Lourenço";
  String imagemUsuario = "assets/images/icone_perfil.jpg";
  int paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text('Olá, $nomeUsuario'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(imagemUsuario),
              radius: 30,
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ListaHQsFavoritas(),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recomendações:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ListaRecomendacoes(),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Populares no momento:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ListaPopulares(),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Lançamentos:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ListaLancamentos(),
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

  // Função para atualizar a página conforme a navegação
  void _atualizarPagina(int index) {
    setState(() {
      paginaAtual = index;
    });

    switch (index) {
      case 1:
        // Tela de Busca (falta implementar essa aba)
        // Navigator.pushNamed(context, '/buscar');
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


class ListaHQsFavoritas extends StatelessWidget {
  final List<String> hqsFavoritas = [
    'assets/images/HQs/Fav/homem_aranha.jpg',
    'assets/images/HQs/Fav/batman.jpg',
    'assets/images/HQs/Fav/aranha_uniforme.jpg',
    'assets/images/HQs/Fav/aranha_wolverine.jpg',
    'assets/images/HQs/Fav/dr_manhatan.jpeg',
    'assets/images/HQs/Fav/MulherMaravilha.jpg',
    'assets/images/HQs/Fav/drman.jpg',
    'assets/images/HQs/Fav/liga.jpeg',
    'assets/images/HQs/Fav/batmanarm.jpg',
    'assets/images/HQs/Fav/simpsons.jpg',
    'assets/images/HQs/Fav/super.jpeg',
    'assets/images/HQs/Fav/turma.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hqsFavoritas.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("Imagem Favoritas ${index + 1} clicada!");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                hqsFavoritas[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: 115,
              ),
            ),
          );
        },
      ),
    );
  }
}


class ListaRecomendacoes extends StatelessWidget {
  final List<String> Recomendacoes = [
    'assets/images/imagemhq.jpg',
  ];
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Recomendacoes.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("Imagem Recomendações ${index + 1} clicada!");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Recomendacoes[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: 115,
              ),
            ),
          );
        },
      ),
    );
  }
}


class ListaPopulares extends StatelessWidget {
  final List<String> Populares = [
    "assets/images/HQs/Popu/drman.jpg",
    "assets/images/HQs/Popu/liga.jpeg",
    "assets/images/HQs/Popu/batmanarm.jpg",
    "assets/images/HQs/Popu/dead.jpeg",
  ];


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Populares.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("Imagem Populares ${index + 1} clicada!");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Populares[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: 115,
              ),
            ),
          );
        },
      ),
    );
  }
}


class ListaLancamentos extends StatelessWidget {
  final List<String> Lancamentos = [
  "assets/images/HQs/Lan/simpsons.jpg",
  "assets/images/HQs/Lan/super.jpeg",
  "assets/images/HQs/Lan/turma.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Lancamentos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("Imagem Lançamentos ${index + 1} clicada!");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Lancamentos[index],
                fit: BoxFit.cover,
                height: double.infinity,
                width: 115,
              ),
            ),
          );
        },
      ),
    );
  }
}