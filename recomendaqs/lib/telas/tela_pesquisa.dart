import 'package:flutter/material.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key? key}) : super(key: key);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class HQ {
  final String title;
  final String imagePath;
  final List<String> informacoes;

  HQ(this.title, this.imagePath, this.informacoes);
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  int paginaAtual = 0;

  List<HQ> historicoDeBusca = [
    HQ('Homem-Aranha', 'assets/images/HQs/Fav/homem_aranha.jpg',
        ['Gênero: Super-Herói', 'Ano: 2022']),
    HQ('Batman', 'assets/images/HQs/Fav/batman.jpg',
        ['Gênero: Super-Herói', 'Ano: 2021']),
    HQ('Mulher Maravilha', 'assets/images/HQs/Fav/MulherMaravilha.jpg',
        ['Gênero: Super-Herói', 'Ano: 2020']),
    HQ('Liga da Justiça', 'assets/images/HQs/Fav/liga.jpeg',
        ['Gênero: Super-Herói', 'Ano: 2023']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: const Text(''),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const <Widget>[],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'O que você deseja?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Digite aqui...',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Histórico de Busca',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Exibindo as últimas 4 HQs
                  for (int i = 0;
                      i < 4 && i < historicoDeBusca.length;
                      i++) ...[
                    Row(
                      children: [
                        Image.asset(
                          historicoDeBusca[i].imagePath,
                          height: 100.0,
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              historicoDeBusca[i].title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            for (String info
                                in historicoDeBusca[i].informacoes) ...[
                              Text(
                                info,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0), // Espaçamento entre as HQs
                  ],
                ],
              ),
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

      // Adicionando a lógica de navegação para as páginas desejadas
      if (index == 0) {
        Navigator.pushNamed(context, '/inicial');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/perfil');
      }
    });
    switch (index) {
      case 1:
        // Tela de Busca
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
