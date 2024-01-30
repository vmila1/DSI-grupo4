import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class HqPage extends StatefulWidget {
  final String hqDocumentName;

  const HqPage(
      {super.key, required this.hqDocumentName, required String imagemHQ});

  @override
  _HqPageState createState() => _HqPageState();
}

class _HqPageState extends State<HqPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> hqData;
  late List<String> generos = [];

  bool favorito = false;
  bool lido = false;
  String nomeUsuario = '';
  String hqID = '';
  String anosLancamento = '';
  String link = '';

  final TextEditingController _textEditingController = TextEditingController();

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

        // Atualiza o nome do usuário nos comentários
        await _atualizarNomeUsuarioComentarios(user.uid);

        await _verificarFavorito();

        await _verificarLido();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  Future<void> _atualizarNomeUsuarioComentarios(String uid) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('HQs')
          .doc(widget.hqDocumentName)
          .get();

      if (snapshot.exists) {
        var comentarios = snapshot.get('comentarios') as List<dynamic>? ?? [];

        for (var comentario in comentarios) {
          if (comentario['uid'] == uid) {
            comentario['name'] = nomeUsuario;
          }
        }

        // Atualiza os dados no Firebase
        await FirebaseFirestore.instance
            .collection('HQs')
            .doc(widget.hqDocumentName)
            .update({'comentarios': comentarios});
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao atualizar nome do usuário nos comentários: $e');
    }
  }

  Future<void> _verificarFavorito() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var uid = user.uid;
        var userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userDoc.exists) {
          var hqsFavoritas =
              userDoc.get('HQsFavoritas') as List<dynamic>? ?? [];

          // Verifica se o ID da HQ está na lista de favoritos
          if (hqsFavoritas.contains(hqID)) {
            setState(() {
              favorito = true;
            });
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao verificar favorito: $e');
    }
  }

  Future<void> _verificarLido() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var uid = user.uid;
        var userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userDoc.exists) {
          var hqsLidas = userDoc.get('HQsLidas') as List<dynamic>? ?? [];

          // Verifica se o ID da HQ está na lista de HQs lidas
          if (hqsLidas.contains(hqID)) {
            setState(() {
              lido = true;
            });
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao verificar lido: $e');
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

      hqID = hqDocument.id;

      var anoLancamentoList = hqDocument['anoLançamento'] as List<dynamic>?;

      var ano = 'Não informado';
      var mes = 'Não informado';
      var dia = 'Não informado';

      if (anoLancamentoList != null && anoLancamentoList.length >= 3) {
        ano = anoLancamentoList[0].toString();
        mes = anoLancamentoList[1].toString();
        dia = anoLancamentoList[2].toString();
      }

      anosLancamento = '$dia/$mes/$ano';
    });

    return hqDocument;
  }

  void _marcarComoFavorito() {
    setState(() {
      favorito = !favorito;
    });

    // Adiciona ou remove o ID da HQ na lista de favoritos do usuário
    _atualizarListaUsuarios(favorito, 'HQsFavoritas', hqID);
  }

  void _marcarComoLido() {
    setState(() {
      lido = !lido;
    });

    // Adicione ou remove o ID da HQ à lista de HQs lidas do usuário
    _atualizarListaUsuarios(lido, 'HQsLidas', hqID);
  }

  void _atualizarListaUsuarios(bool adicionar, String campo, String hqID) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var uid = user.uid;

      FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          var dadosUsuario = documentSnapshot.data() as Map<String, dynamic>;
          var lista = List<String>.from(dadosUsuario[campo] ?? []);

          if (adicionar) {
            // Adiciona o ID da HQ à lista
            lista.add(hqID);
          } else {
            // Remove o ID da HQ da lista
            lista.remove(hqID);
          }

          // Atualiza a lista no Firebase
          FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .update({campo: lista});
        }
      }).catchError((error) {
        // ignore: avoid_print
        print('Erro ao atualizar lista do usuário: $error');
      });
    }
  }

  Widget _itemChats({
    required String uid,
    required String name,
    required String chat,
  }) {
    bool hasPermission = uid == FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        chat,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasPermission)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _exibirTelaEdicao(uid, name, chat);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _exibirConfirmacaoExclusao(uid, name, chat);
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

  void _exibirTelaEdicao(String uid, String name, String chat) async {
    TextEditingController _textEditingControllerEdicao =
        TextEditingController();
    _textEditingControllerEdicao.text = chat;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Comentário'),
          content: TextField(
            controller: _textEditingControllerEdicao,
            decoration: const InputDecoration(
              hintText: 'Digite seu comentário...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
                _editarComentario(
                    uid, name, chat, _textEditingControllerEdicao.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editarComentario(
      String uid, String name, String chatAntigo, String novoComentario) {
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
          if (comentario['uid'] == uid &&
              comentario['name'] == name &&
              comentario['chat'] == chatAntigo) {
            comentario['chat'] = novoComentario;
            comentario['name'] = nomeUsuario; // Atualiza o nome do usuário
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
      // ignore: avoid_print
      print('Erro ao editar comentário: $error');
    });
  }

  void _exibirConfirmacaoExclusao(String uid, String name, String chat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Deseja realmente apagar seu comentário?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
                _apagarComentario(uid, name, chat);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _apagarComentario(String uid, String name, String chat) {
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
              comentario['uid'] == uid &&
              comentario['name'] == name &&
              comentario['chat'] == chat,
        );

        FirebaseFirestore.instance
            .collection('HQs')
            .doc(widget.hqDocumentName)
            .update({'comentarios': comentarios});
      }
    }).catchError((error) {
      // ignore: avoid_print
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (generos.isNotEmpty)
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
            return _buildLoadingScreen();
          }

          if (snapshot.hasError) {
            return _buildErrorScreen();
          }

          var hqData = snapshot.data!.data()!;

          generos = (hqData['generoQuadrinho'] as List<dynamic>?)
                  ?.map((genero) => genero.toString())
                  .toList() ??
              [];

          return Stack(
            children: [
              Image.asset(
                'assets/images/telafundo.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.bottom +
                      AppBar().preferredSize.height +
                      5.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppBar().preferredSize.height),
                    Text(
                      hqData['nomeQuadrinho'] ?? 'Nome não informado',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Image.network(
                      hqData['imagem'] ?? '',
                      fit: BoxFit.contain,
                      height: 400,
                      width: 400,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 5),
                        Text(
                          '${hqData['avaliacao'] ?? 'Não avaliado'}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 60),
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 5),
                        Text(
                          '${hqData['preco'] ?? 'Não informado'}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text('Ano(s) de Lançamento: $anosLancamento',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumo: ${hqData['resumo'] ?? 'Não informado'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (hqData['link'] != null &&
                                  hqData['link'].isNotEmpty) {
                                try {
                                  if (await canLaunch(hqData['link']!)) {
                                    await launch(hqData['link']!);
                                  } else {
                                    print(
                                        'Não foi possível abrir a URL: ${hqData['link']}');
                                  }
                                } catch (e) {
                                  print('Erro ao lançar a URL: $e');
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Link para compra: ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      hqData['link'] ?? 'Não informado',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _marcarComoFavorito();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: favorito
                                ? Colors.red
                                : const Color.fromARGB(255, 216, 216, 216),
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
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 65, 64, 64),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            _marcarComoLido();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: lido
                                ? Colors.blue
                                : const Color.fromARGB(255, 216, 216, 216),
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
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 65, 64, 64),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Comentários:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('HQs')
                                .doc(widget.hqDocumentName)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              var comentarios = snapshot.data!
                                      .get('comentarios') as List<dynamic>? ??
                                  [];

                              return Container(
                                color: Colors.white.withOpacity(0),
                                child: Column(
                                  children: [
                                    for (var comentario in comentarios)
                                      _itemChats(
                                        name: comentario['name'],
                                        chat: comentario['chat'],
                                        uid: comentario['uid'],
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite seu comentário...',
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _adicionarComentario();
                                },
                                icon: const Icon(Icons.send),
                                label: const Text(''),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: const Text(
          'Carregando...',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/telafundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: const Text('Erro'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/telafundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text('Erro ao carregar os dados da HQ.'),
        ),
      ),
    );
  }

  void _adicionarComentario() {
    String comentario = _textEditingController.text.trim();

    if (comentario.isNotEmpty && nomeUsuario.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user?.uid ?? "";

      FirebaseFirestore.instance
          .collection('HQs')
          .doc(widget.hqDocumentName)
          .get()
          .then((documentSnapshot) {
        if (documentSnapshot.exists) {
          var comentarios =
              documentSnapshot.get('comentarios') as List<dynamic>? ?? [];

          comentarios
              .add({'uid': uid, 'name': nomeUsuario, 'chat': comentario});

          FirebaseFirestore.instance
              .collection('HQs')
              .doc(widget.hqDocumentName)
              .update({'comentarios': comentarios});

          _textEditingController.clear();
        }
      }).catchError((error) {
        // ignore: avoid_print
        print('Erro ao adicionar comentário: $error');
      });
    }
  }
}

class GeneroWidget extends StatelessWidget {
  final List<String> generos;
  final int maxGeneros;

  const GeneroWidget({Key? key, required this.generos, this.maxGeneros = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(86, 83, 255, 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: generos.take(maxGeneros).map((genero) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                label: Text(
                  genero,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
                shape: const StadiumBorder(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
