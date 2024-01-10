import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaAddHq extends StatefulWidget {
  final bool edicao;
  final Map<String, dynamic>? hq;

  TelaAddHq({Key? key, required this.edicao, this.hq}) : super(key: key);

  @override
  _TelaAddHqState createState() => _TelaAddHqState();
}

class _TelaAddHqState extends State<TelaAddHq> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _resumoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();
  final TextEditingController _anolancController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _nomepersController = TextEditingController();
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.edicao) {
      _carregarDadosHQ();
    }
  }

  void _carregarDadosHQ() {
    _nomeController.text = widget.hq?['nomeQuadrinho'] ?? '';
    _generoController.text = (widget.hq?['generoQuadrinho'] as List<dynamic>?)?.join(',') ?? '';
    _resumoController.text = widget.hq?['resumo'] ?? '';
    _imagemController.text = widget.hq?['imagem'] ?? '';
    _anolancController.text = (widget.hq?['anoLançamento'] as List<dynamic>?)?.join(',') ?? '';
    _precoController.text = widget.hq?['preco'] ?? '';
    _nomepersController.text = widget.hq?['nomePersonagem'] ?? '';
  }

  Future<String?> _adicionarHQ(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String randomId = DateTime.now().millisecondsSinceEpoch.toString();

        final hqData = {
          'id': randomId,
          'nomeQuadrinho': _nomeController.text,
          'generoQuadrinho': _generoController.text.split(','),
          'resumo': _resumoController.text,
          'imagem': _imagemController.text,
          'anoLançamento': _anolancController.text.split(','),
          'preco': _precoController.text,
          'nomePersonagem': _nomepersController.text,
        };

        // Adicionar à coleção geral
        await FirebaseFirestore.instance
            .collection('HQs')
            .doc(randomId)
            .set(hqData);

        if (user != null) {
          final uid = user.uid;

          // Adicionar à coleção do usuário
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('HQs')
              .doc(randomId)
              .set(hqData);
        }

        return randomId; // Retorna o ID da HQ adicionada
      }
    } catch (e) {
      // Tratar o erro conforme necessário
      print('Erro ao adicionar HQ: $e');
    }

    return null; // Retorna null em caso de erro
  }

  void _editarHQ(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && widget.edicao) {
        final uid = user.uid;

        // Lógica para editar o HQ usando hqId
        // Atualize os dados no Firebase ou no local de armazenamento

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('HQ editada com sucesso! ID: ${widget.hq?['id']}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Erro ao editar HQ: $e');
      // Tratar o erro conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text(widget.edicao ? 'Editar HQ' : 'Adicionar HQ'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome da HQ',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  // Adicione os outros TextFields conforme necessário...
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget.edicao) {
                        _editarHQ(context);
                      } else {
                        final novoHQId = await _adicionarHQ(context);

                        if (novoHQId != null) {
                          Navigator.pop(context, novoHQId);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5653FF),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(widget.edicao ? 'Editar HQ' : 'Adicionar HQ'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
