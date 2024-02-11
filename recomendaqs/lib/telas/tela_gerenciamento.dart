import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_addhq.dart';
import 'package:recomendaqs/telas/tela_hq.dart';
import 'package:recomendaqs/telas/tela_pesquisa.dart';

class TelaGerenciaHq extends StatefulWidget {
  const TelaGerenciaHq({Key? key}) : super(key: key);

  @override
  _TelaGerenciaHqState createState() => _TelaGerenciaHqState();
}

class _TelaGerenciaHqState extends State<TelaGerenciaHq> {
  List<Map<String, dynamic>> minhasHQs = [];
  List<Map<String, dynamic>> resultadosDaBusca = [];
  final TextEditingController _controllerPesquisa = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarHQs();
  }

  void _navegarParaTelaHQ(String hqId) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HqPage(
            hqDocumentName: hqId,
            imagemHQ: '',
          ),
        ),
      );
    } catch (e) {
      print('Erro ao navegar para a HQ: $e');
    }
  }

  void _carregarHQs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('HQs_users')
          .get();

      setState(() {
        minhasHQs = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  void _editarHQ(BuildContext context, Map<String, dynamic> hq) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaAddHq(
          edicao: true,
          hq: hq,
          atualizarNomeQuadrinho: (novoNome) {
            _atualizarNomeQuadrinho(hq['id'], novoNome);
          },
        ),
      ),
    );

    if (resultado != null && resultado is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ editada com sucesso! ID: $resultado'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      final index =
          minhasHQs.indexWhere((element) => element['id'] == hq['id']);
      if (index != -1) {
        setState(() {
          minhasHQs[index]['nomeQuadrinho'] = resultado;
        });
      }
    }
  }

  void _atualizarNomeQuadrinho(String id, String novoNome) {
    final index = minhasHQs.indexWhere((element) => element['id'] == id);
    if (index != -1) {
      setState(() {
        minhasHQs[index]['nomeQuadrinho'] = novoNome;
      });
    }
  }

  void _exibirConfirmacaoExclusao(String hqId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Deseja realmente apagar sua HQ?'),
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
                _apagarHQ(context, hqId);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _apagarHQ(BuildContext context, String hqId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      
      final scaffoldMessenger = ScaffoldMessenger.of(context); // Armazena uma referência para o ScaffoldMessenger
      
      try {
        await FirebaseFirestore.instance.collection('HQs').doc(hqId).delete();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('HQs_users')
            .doc(hqId)
            .delete();

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('HQ excluída com sucesso! ID: $hqId'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Atualizar a lista de HQs após a exclusão
        _carregarHQs();
      } catch (e) {
        print('Erro ao excluir HQ: $e');
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir HQ'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  void _pesquisarHQs(String query) {
    setState(() {
      resultadosDaBusca.clear();
    });

    String queryUpperCase = query.toUpperCase();

    for (var hq in minhasHQs) {
      String nomeQuadrinho = hq['nomeQuadrinho'] ?? '';
      if (nomeQuadrinho.toUpperCase().contains(queryUpperCase)) {
        setState(() {
          resultadosDaBusca.add({
            'id': hq['id'],
            'nomeQuadrinho': nomeQuadrinho,
            'imagem': hq['imagem'],
          });
        });
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
      title: Text(
        'Minhas HQs',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/perfil');
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _pesquisarHQs(_controllerPesquisa.text);
          },
        ),
      ],
    ),
    body: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerPesquisa,
              onChanged: _pesquisarHQs, // Chama _pesquisarHQs sempre que o texto mudar

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white, // Define a cor de fundo como branca
                hintText: 'Pesquisar HQs',
                hintStyle: TextStyle(color: Colors.black), // Define a cor do hintText como preto
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Remove as bordas do TextField
                  borderRadius: BorderRadius.circular(8.0), // Define a borda do TextField
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildHQList(),
          ],
        ),
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final novoHQ = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TelaAddHq(
                    edicao: false,
                    atualizarNomeQuadrinho: (String) {},
                  )),
        );

        if (novoHQ != null && novoHQ is String) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('HQ adicionada com sucesso! ID: $novoHQ'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
          _carregarHQs();
        }
      },
      child: Icon(Icons.add),
    ),
  );
}


  Widget _buildHQList() {
    List<Map<String, dynamic>> listaExibida =
        resultadosDaBusca.isNotEmpty ? resultadosDaBusca : minhasHQs;

    if (listaExibida != null && listaExibida.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true, // Adicionado para evitar o erro de tamanho indefinido
        physics:
            NeverScrollableScrollPhysics(), // Impede a rolagem dentro da ListView
        itemCount: listaExibida.length,
        itemBuilder: (context, index) {
          final hq = listaExibida[index];
          final hqId = hq['id'];

          return GestureDetector(
            onTap: () {
              _navegarParaTelaHQ(hqId);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                border: Border.all(
                  color: Colors.white, // Definindo a cor da borda como branca
                  width: 1.0,
                ),
              ),
              child: ListTile(
                title: Text(
                  hq['nomeQuadrinho'] ?? 'Nome Indisponível',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editarHQ(context, hq);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _exibirConfirmacaoExclusao(hqId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          'Nenhuma HQ encontrada.',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }
}
