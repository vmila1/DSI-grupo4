import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_addhq.dart';

class TelaGerenciaHq extends StatefulWidget {
  const TelaGerenciaHq({Key? key}) : super(key: key);

  @override
  _TelaGerenciaHqState createState() => _TelaGerenciaHqState();
}

class _TelaGerenciaHqState extends State<TelaGerenciaHq> {
  List<Map<String, dynamic>> minhasHQs =
      []; // Lista de mapas para armazenar dados das HQs

  @override
  void initState() {
    super.initState();
    _carregarHQs(); // Carrega as HQs ao iniciar a tela
  }

  void _carregarHQs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('HQs')
          .get();

      setState(() {
        minhasHQs = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  void _editarHQ(BuildContext context, Map<String, dynamic> hq) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaAddHq(edicao: true, hq: hq)),
    );

    if (resultado != null && resultado is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ editada com sucesso! ID: $resultado'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      _carregarHQs(); // Recarrega as HQs após a edição
    }
  }

  void _excluirHQ(BuildContext context, String hqId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('HQs')
          .doc(hqId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ excluída com sucesso! ID: $hqId'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      _carregarHQs(); // Recarrega as HQs após a exclusão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text('Minhas HQs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
          _buildHQList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novoHQ = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaAddHq(edicao: false)),
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

        return Column(
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
                        _excluirHQ(context, hqId);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
