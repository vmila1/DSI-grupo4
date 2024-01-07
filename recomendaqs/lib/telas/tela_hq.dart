import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String nomeUsuario = '';

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hqData = _carregarDadosHQ(widget.hqDocumentName);
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
    required String name,
    required String chat,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        chat,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (name == nomeUsuario)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white, // Defina a cor para branca
                        ),
                        onPressed: () {
                          _exibirTelaEdicao(name, chat);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white, // Defina a cor para branca
                        ),
                        onPressed: () {
                          _exibirConfirmacaoExclusao(name, chat);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exibirTelaEdicao(String name, String chat) async {
    TextEditingController _textEditingControllerEdicao =
        TextEditingController();
    _textEditingControllerEdicao.text = chat;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Comentário'),
          content: TextField(
            controller: _textEditingControllerEdicao,
            decoration: InputDecoration(
              hintText: 'Digite seu comentário...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
                _editarComentario(
                    name, chat, _textEditingControllerEdicao.text);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editarComentario(
      String name, String chatAntigo, String novoComentario) {
    FirebaseFirestore.instance
        .collection('HQs')
        .doc(widget.hqDocumentName)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        var comentarios =
            documentSnapshot.get('comentarios') as List<dynamic>? ?? [];

        // Encontra o comentário antigo e o substitui pelo novo
        for (var comentario in comentarios) {
          if (comentario['name'] == name && comentario['chat'] == chatAntigo) {
            comentario['chat'] = novoComentario;
            break;
          }
        }

        // Atualiza os dados no Firebase
        FirebaseFirestore.instance
            .collection('HQs')
            .doc(widget.hqDocumentName)
            .update({'comentarios': comentarios});
      }
    }).catchError((error) {
      print('Erro ao editar comentário: $error');
    });
  }

  void _exibirConfirmacaoExclusao(String name, String chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Deseja realmente apagar seu comentário?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
                _apagarComentario(name, chat);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _apagarComentario(String name, String chat) {
    FirebaseFirestore.instance
        .collection('HQs')
        .doc(widget.hqDocumentName)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        var comentarios =
            documentSnapshot.get('comentarios') as List<dynamic>? ?? [];

        comentarios.removeWhere(
          (comentario) =>
              comentario['name'] == name && comentario['chat'] == chat,
        );

        FirebaseFirestore.instance
            .collection('HQs')
            .doc(widget.hqDocumentName)
            .update({'comentarios': comentarios});
      }
    }).catchError((error) {
      print('Erro ao apagar comentário: $error');
    });
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
          // ignore: unnecessary_null_comparison
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
          // ignore: unused_local_variable
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
                    SizedBox(height: 40.0),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        )),
                    Text('Resumo: ${hqData['resumo'] ?? 'Não informado'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
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
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('HQs')
                              .doc(widget.hqDocumentName)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            var comentarios = snapshot.data!.get('comentarios')
                                    as List<dynamic>? ??
                                [];

                            return Container(
                              color: Colors.white
                                  .withOpacity(0), // Adicione a opacidade aqui
                              child: Column(
                                children: [
                                  for (var comentario in comentarios)
                                    _itemChats(
                                      name: comentario['name'],
                                      chat: comentario['chat'],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Digite seu comentário...',
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                _adicionarComentario();
                              },
                              icon: Icon(Icons.send),
                              label: Text(''),
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .transparent, // Defina a cor do fundo como transparente
                                elevation: 0, // Remova a sombra do botão
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _adicionarComentario() {
    String comentario = _textEditingController.text.trim();

    if (comentario.isNotEmpty && nomeUsuario.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('HQs')
          .doc(widget.hqDocumentName)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          var comentarios =
              documentSnapshot.get('comentarios') as List<dynamic>? ?? [];

          comentarios.add({'name': nomeUsuario, 'chat': comentario});

          FirebaseFirestore.instance
              .collection('HQs')
              .doc(widget.hqDocumentName)
              .update({'comentarios': comentarios});

          _textEditingController.clear();
        }
      }).catchError((error) {
        print('Erro ao adicionar comentário: $error');
      });
    }
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
