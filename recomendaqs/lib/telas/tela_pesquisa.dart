// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

class TelaPesquisa extends StatefulWidget {
  const TelaPesquisa({Key? key}) : super(key: key);

  @override
  _TelaPesquisaState createState() => _TelaPesquisaState();
}

class HQ {
  final String id;
  final String title;
  final String imageUrl;
  final List<String> informacoes;

  HQ(this.id, this.title, this.imageUrl, this.informacoes);
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  int paginaAtual = 1;
  List<HQ> historicoDeBusca = [];
  List<HQ> resultadosDaBusca = [];
  List<String> generos = [];
  List<String> generosSelecionados = [];
  TextEditingController pesquisaController = TextEditingController();
  bool historicoVisivel = true;

  @override
  void initState() {
    super.initState();
    _carregarHistoricoDeBusca();
    _carregarGeneros();
    pesquisaController.addListener(_Mudanca_de_Texto);
  }

  Future<void> _carregarHistoricoDeBusca() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var uid = user.uid;
        var userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userDoc.exists) {
          var historicoIds = userDoc.get('UserHistorico') as List<dynamic>? ?? [];

          historicoIds = historicoIds.reversed.toList();

          historicoDeBusca.clear();

          for (var hqId in historicoIds) {
            var hqDoc = await FirebaseFirestore.instance.collection('HQs').doc(hqId).get();

            if (hqDoc.exists) {
              var hqData = hqDoc.data()!;
              var anoLancamentoList = hqData['anoLançamento'] as List<dynamic>?;

              var ano = 'Não informado';
              var mes = 'Não informado';
              var dia = 'Não informado';

              if (anoLancamentoList != null && anoLancamentoList.length >= 3) {
                ano = anoLancamentoList[0].toString();
                mes = anoLancamentoList[1].toString();
                dia = anoLancamentoList[2].toString();
              }

              var anoLancamentoFormatado = '$dia/$mes/$ano';

              historicoDeBusca.add(HQ(
                hqDoc.id,
                hqData['nomeQuadrinho'] ?? '',
                hqData['imagem'] ?? '',
                [
                  'Ano de Lançamento: $anoLancamentoFormatado',
                  'Gênero: ${hqData['generoQuadrinho'] ?? 'Não informado'}',
                ],
              ));
            }
          }

          setState(() {});
        }
      }
    } catch (e) {
      print('Erro ao carregar histórico de busca: $e');
    }
  }

  Future<void> _carregarGeneros() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('HQs').get();

      Set<String> generosSet = <String>{};

      for (var doc in querySnapshot.docs) {
        var generoList = doc['generoQuadrinho'] as List<dynamic>? ?? [];
        generosSet.addAll(generoList.map((e) => e.toString()));
      }

      generos = generosSet.toList();
      generos.sort();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar gêneros: $e');
    }
  }

  Future<void> _pesquisarHQs(String query) async {
    try {
      String queryUpperCase = query.toUpperCase();

      var snapshot = await FirebaseFirestore.instance.collection('HQs').where('nomeQuadrinho', isGreaterThanOrEqualTo: queryUpperCase).get();

      resultadosDaBusca.clear();

      int resultadosMaximos = 7;

      for (var hqDoc in snapshot.docs) {
        if (resultadosDaBusca.length >= resultadosMaximos) {
          break;
        }

        var hqData = hqDoc.data();
        var anoLancamentoList = hqData['anoLançamento'] as List<dynamic>?;

        var ano = 'Não informado';
        var mes = 'Não informado';
        var dia = 'Não informado';

        if (anoLancamentoList != null && anoLancamentoList.length >= 3) {
          ano = anoLancamentoList[0].toString();
          mes = anoLancamentoList[1].toString();
          dia = anoLancamentoList[2].toString();
        }

        var anoLancamentoFormatado = '$dia/$mes/$ano';

        resultadosDaBusca.add(HQ(
          hqDoc.id,
          hqData['nomeQuadrinho'] ?? '',
          hqData['imagem'] ?? '',
          [
            'Ano de Lançamento: $anoLancamentoFormatado',
            'Gênero: ${hqData['generoQuadrinho'] ?? 'Não informado'}',
          ],
        ));
      }

      setState(() {});
    } catch (e) {
      print('Erro ao pesquisar HQs: $e');
    }
  }

  void _atualizarHistoricoDoUsuario(String hqId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var uid = user.uid;

        var userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        if (userDoc.exists) {
          var historicoIds = userDoc.get('UserHistorico') as List<dynamic>? ?? [];

          historicoIds.remove(hqId);

          historicoIds.add(hqId);

          await FirebaseFirestore.instance.collection('Users').doc(uid).update({'UserHistorico': historicoIds});

          // Atualiza o histórico após a atualização do usuário
          _carregarHistoricoDeBusca();
        }
      }
    } catch (e) {
      print('Erro ao atualizar histórico do usuário: $e');
    }
  }

  void _removerHQDoHistorico(String hqId, String hqTitle) async {
    try {
      bool confirmacao = await _mostrarConfirmacaoRemocao(hqTitle);

      if (confirmacao) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          var uid = user.uid;

          var userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

          if (userDoc.exists) {
            var historicoIds = userDoc.get('UserHistorico') as List<dynamic>? ?? [];

            historicoIds.remove(hqId);

            await FirebaseFirestore.instance.collection('Users').doc(uid).update({'UserHistorico': historicoIds});

            // Atualiza o histórico após a remoção
            _carregarHistoricoDeBusca();
          }
        }
      }
    } catch (e) {
      print('Erro ao remover HQ do histórico: $e');
    }
  }

  void _pesquisarPorGenero(String genero) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('HQs').where('generoQuadrinho', arrayContains: genero).get();

      resultadosDaBusca.clear();

      for (var hqDoc in snapshot.docs) {
        var hqData = hqDoc.data();
        var anoLancamentoList = hqData['anoLançamento'] as List<dynamic>?;

        var ano = 'Não informado';
        var mes = 'Não informado';
        var dia = 'Não informado';

        if (anoLancamentoList != null && anoLancamentoList.length >= 3) {
          ano = anoLancamentoList[0].toString();
          mes = anoLancamentoList[1].toString();
          dia = anoLancamentoList[2].toString();
        }

        var anoLancamentoFormatado = '$dia/$mes/$ano';

        resultadosDaBusca.add(HQ(
          hqDoc.id,
          hqData['nomeQuadrinho'] ?? '',
          hqData['imagem'] ?? '',
          [
            'Ano de Lançamento: $anoLancamentoFormatado',
            'Gênero: ${hqData['generoQuadrinho'] ?? 'Não informado'}',
          ],
        ));
      }

      setState(() {});
    } catch (e) {
      print('Erro ao pesquisar por gênero: $e');
    }
  }

  Future<bool> _mostrarConfirmacaoRemocao(String hqTitle) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: Text('Deseja realmente remover "$hqTitle" do histórico?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  void _Mudanca_de_Texto() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (pesquisaController.text.isEmpty && generosSelecionados.isEmpty) {
        _carregarHistoricoDeBusca();
      }
    });
  }

  void _onGeneroButtonPressed(String genero) {
    _pesquisarPorGenero(genero);
    setState(() {
      if (generosSelecionados.contains(genero)) {
        // Remove o gênero da lista se já estiver selecionado
        generosSelecionados.remove(genero);
      } else if (generosSelecionados.length < 3) {
        // Adiciona o gênero à lista se o máximo de 3 não for atingido
        generosSelecionados.add(genero);
      } else {
        // Exibe uma mensagem de aviso quando o máximo é atingido
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Máximo de 3 gêneros atingido',
              style: TextStyle(color: Colors.red),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    });
  }

  // Método para construir os botões de gênero em uma lista horizontal rolável
  Widget _buildGeneroButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: generos
            .map(
              (genero) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onGeneroButtonPressed(genero);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (generosSelecionados.contains(genero)) {
                          return const Color.fromRGBO(86, 83, 255, 1);
                        } else if (states.contains(MaterialState.pressed)) {
                          return const Color.fromRGBO(86, 83, 255, 1);
                        }
                        return Colors.transparent;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Text(
                    genero,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

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
                  const SizedBox(height: 16.0),
                  // Caixa de texto
                  TextField(
                    controller: pesquisaController,
                    onTap: () {
                      // Quando a caixa de texto for tocada, esconde o histórico
                      setState(() {
                        historicoVisivel = false;
                      });
                      if (pesquisaController.text.isEmpty && generosSelecionados.isNotEmpty) {
                        // Se a caixa de texto estiver vazia, mas os gêneros foram selecionados, pesquisa automaticamente
                        _pesquisarPorGenero(generosSelecionados.first);
                      }
                    },
                    onChanged: (query) {
                      if (query.isEmpty) {
                        _carregarHistoricoDeBusca();
                        historicoVisivel = true;
                      } else {
                        _pesquisarHQs(query);
                      }
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Digite aqui...',
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Botões de Gênero
                  _buildGeneroButtons(),
                  const SizedBox(height: 24.0),

                  if (historicoVisivel)
                    const Text(
                      'Histórico de Busca',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 8.0),

                  // Resultados da Busca
                  for (int i = 0; i < 4 && i < (historicoVisivel ? historicoDeBusca.length : resultadosDaBusca.length); i++) ...[
                    GestureDetector(
                      onTap: () {
                        _atualizarHistoricoDoUsuario(historicoVisivel ? historicoDeBusca[i].id : resultadosDaBusca[i].id);
                        _navegarParaDetalhesHQ(context, historicoVisivel ? historicoDeBusca[i] : resultadosDaBusca[i]);
                      },
                      child: Row(
                        children: [
                          Image.network(
                            historicoVisivel ? historicoDeBusca[i].imageUrl : resultadosDaBusca[i].imageUrl,
                            height: 100.0,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  historicoVisivel ? historicoDeBusca[i].title : resultadosDaBusca[i].title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                for (String info in historicoVisivel ? historicoDeBusca[i].informacoes : resultadosDaBusca[i].informacoes) ...[
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
                          ),
                          if (historicoVisivel)
                            InkWell(
                              onTap: () {
                                _removerHQDoHistorico(historicoDeBusca[i].id, historicoDeBusca[i].title);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
    });

    switch (index) {
      case 1:
        // Atualiza a página quando navegar para a tela de pesquisa
        _carregarHistoricoDeBusca();
        break;
      case 2:
        Navigator.pushNamed(context, '/perfil');
        break;
      default:
        Navigator.pushNamed(context, '/inicial');
        break;
    }
  }

  void _navegarParaDetalhesHQ(BuildContext context, HQ hq) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HqPage(
          hqDocumentName: hq.id,
          imagemHQ: hq.imageUrl,
        ),
      ),
    );
  }
}