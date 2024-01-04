import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HqPage extends StatefulWidget {
  final String hqDocumentName;

  HqPage({required this.hqDocumentName, required String imagemHQ});

  @override
  _HqPageState createState() => _HqPageState();
}

class _HqPageState extends State<HqPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> hqData;
  late List<String> generos;

  bool favorito = false;
  bool lido = false;

  TextEditingController _textEditingController = TextEditingController();

  List<Map<String, String>> comentarios = [
    {
      'avatar': 'assets/images/icone_perfil.jpg',
      'name': 'João',
      'chat': 'Quadrinho top demais',
      'time': '15:30',
    },
    {
      'avatar': 'assets/images/avatar.jpg',
      'name': 'Maria',
      'chat': 'Achei ruim',
      'time': '15:32',
    },
    {
      'avatar': 'assets/images/avatar2.jpg',
      'name': 'Pedro',
      'chat': 'Gostei! massa.',
      'time': '15:32',
    },
  ];

  @override
  void initState() {
    super.initState();
    hqData = _carregarDadosHQ(widget.hqDocumentName);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _carregarDadosHQ(
      String documentName) async {
    var hqDocument = await FirebaseFirestore.instance
        .collection('HQs')
        .doc(documentName)
        .get();

    setState(() {
      generos = (hqDocument['generoQuadrinho'] as List<dynamic>?)
              ?.map((genero) => genero.toString())
              .toList() ??
          [];
    });

    return hqDocument;
  }

  void _marcarComoFavorito() {
    setState(() {
      favorito = !favorito;
    });
  }

  void _marcarComoLido() {
    setState(() {
      lido = !lido;
    });
  }

  Widget _itemChats({
    required String avatar,
    required String name,
    required String chat,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Avatar(
            margin: EdgeInsets.only(right: 15),
            size: 40,
            image: avatar,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                chat,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (generos != null && generos.isNotEmpty)
            Expanded(
              child: Center(
                child: GeneroWidget(generos: generos),
              ),
            ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: hqData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var hqData = snapshot.data!.data()!;
          var generoQuadrinho =
              hqData['generoQuadrinho'] ?? 'Gênero não informado';
          var anosLancamento = (hqData['anoLançamento'] as List<dynamic>?)
                  ?.map((ano) => ano.toString())
                  .toList()
                  .join('/') ??
              'Não informado';

          return Stack(
            children: [
              Image.asset(
                'assets/images/telafundo.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 40.0), // Adiciona um espaço acima do título
                    Text(
                      hqData['nomeQuadrinho'] ?? 'Nome não informado',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Image.network(
                      hqData['imagem'] ?? '',
                      fit: BoxFit.contain,
                      height: 400,
                      width: 400,
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 5),
                        Text(
                          '${hqData['avaliacao'] ?? 'Não avaliado'}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 60),
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          '${hqData['preco'] ?? 'Não informado'}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text('Ano(s) de Lançamento: $anosLancamento',
                        style: TextStyle(color: Colors.white)),
                    Text('Resumo: ${hqData['resumo'] ?? 'Não informado'}',
                        style: TextStyle(color: Colors.white)),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              favorito = !favorito;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: favorito
                                ? Colors.red
                                : const Color.fromARGB(255, 216, 216, 216),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(
                            favorito ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                          ),
                          label: Text(
                            favorito ? 'Favoritado' : 'Favoritar',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 65, 64, 64),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              lido = !lido;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: lido
                                ? Colors.blue
                                : const Color.fromARGB(255, 216, 216, 216),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: Icon(
                            lido ? Icons.bookmark : Icons.bookmark_outline,
                            size: 24,
                          ),
                          label: Text(
                            lido ? 'Lido' : 'Marcar como lido',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 65, 64, 64),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comentários:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              for (var comentario in comentarios)
                                _itemChats(
                                  avatar: comentario['avatar']!,
                                  name: comentario['name']!,
                                  chat: comentario['chat']!,
                                  time: comentario['time']!,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Digite seu comentário...',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final dynamic image;
  final EdgeInsets margin;

  Avatar({this.image, this.size = 20, this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(image),
        ),
      ),
    );
  }
}

class GeneroWidget extends StatelessWidget {
  final List<String> generos;

  GeneroWidget({required this.generos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(86, 83, 255, 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: generos.map((genero) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text(
                  genero,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
                shape: StadiumBorder(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
