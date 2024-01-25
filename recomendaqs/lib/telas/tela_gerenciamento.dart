import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_addhq.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

class TelaGerenciaHq extends StatefulWidget {
  const TelaGerenciaHq({Key? key}) : super(key: key);

  @override
  _TelaGerenciaHqState createState() => _TelaGerenciaHqState();
}

class _TelaGerenciaHqState extends State<TelaGerenciaHq> {
  List<Map<String, dynamic>> minhasHQs = [];

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

      await FirebaseFirestore.instance.collection('HQs').doc(hqId).delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('HQs_users')
          .doc(hqId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ excluída com sucesso! ID: $hqId'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      _carregarHQs();
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
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: _buildHQList(),
          ),
        ],
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
    return ListView.builder(
      itemCount: minhasHQs.length,
      itemBuilder: (context, index) {
        final hq = minhasHQs[index];
        final hqId = hq['id'];

        return GestureDetector(
          onTap: () {
            _navegarParaTelaHQ(hqId);
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
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
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          _editarHQ(context, hq);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          _exibirConfirmacaoExclusao(hqId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
