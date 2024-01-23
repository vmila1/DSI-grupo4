import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaAddHq extends StatefulWidget {
  final bool edicao;
  final Map<String, dynamic>? hq;
  final Function(String) atualizarNomeQuadrinho;

  TelaAddHq({
    Key? key,
    required this.edicao,
    this.hq,
    required this.atualizarNomeQuadrinho,
  }) : super(key: key);

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
  
  get hq => null;

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
  

  bool _isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isScheme("http") || uri.isScheme("https");
    } catch (e) {
      // Tratar exceção se a URL não for válida
      return false;
    }
  }

  Future<String?> _adicionarHQ(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String randomId = DateTime.now().millisecondsSinceEpoch.toString();

        final nomeQuadrinho = _nomeController.text;
        final generoQuadrinho = _generoController.text;
        final resumo = _resumoController.text;
        final imagem = _imagemController.text;
        final anoLancamento = _anolancController.text;
        final preco = _precoController.text;
        final nomePersonagem = _nomepersController.text;

        if (nomeQuadrinho.isEmpty ||
            generoQuadrinho.isEmpty ||
            resumo.isEmpty ||
            imagem.isEmpty ||
            anoLancamento.isEmpty ||
            preco.isEmpty ||
            nomePersonagem.isEmpty) {
          // Exibir mensagem informando que todos os campos são obrigatórios
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todos os campos são obrigatórios.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          return null;
        }

        final hqData = {
          'id': randomId,
          'nomeQuadrinho': nomeQuadrinho,
          'generoQuadrinho': generoQuadrinho.split(','),
          'resumo': resumo,
          'imagem': imagem,
          'anoLançamento': anoLancamento.split(','),
          'preco': preco,
          'nomePersonagem': nomePersonagem,
          'comentarios': [],
        };

        await FirebaseFirestore.instance
            .collection('HQs')
            .doc(randomId)
            .set(hqData);

        if (user != null) {
          final uid = user.uid;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('HQs_users')
              .doc(randomId)
              .set(hqData);
        }

        return randomId;
      }
    } catch (e) {
      print('Erro ao adicionar HQ: $e');
    }

    return null;
  }

  void _editarHQ(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && widget.edicao) {
        final uid = user.uid;

        final nomeQuadrinho = _nomeController.text;
        final generoQuadrinho = _generoController.text;
        final resumo = _resumoController.text;
        final imagem = _imagemController.text;
        final anoLancamento = _anolancController.text;
        final preco = _precoController.text;
        final nomePersonagem = _nomepersController.text;

        if (nomeQuadrinho.isEmpty ||
            generoQuadrinho.isEmpty ||
            resumo.isEmpty ||
            imagem.isEmpty ||
            anoLancamento.isEmpty ||
            preco.isEmpty ||
            nomePersonagem.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Todos os campos são obrigatórios.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final hqData = {
          'nomeQuadrinho': nomeQuadrinho,
          'generoQuadrinho': generoQuadrinho.split(','),
          'resumo': resumo,
          'imagem': imagem,
          'anoLançamento': anoLancamento.split('/'), 
          'preco': preco,
          'nomePersonagem': nomePersonagem,
        };

        await FirebaseFirestore.instance
            .collection('HQs')
            .doc(widget.hq?['id'])
            .update(hqData);

        widget.atualizarNomeQuadrinho(nomeQuadrinho); // Atualiza o nome na tela de gerência

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
    }
  }



  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
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
                  SizedBox(height: 16),
                  _buildTextField(
                    _nomeController,
                    'Nome da HQ',
                    'Informe o nome da HQ',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _generoController,
                    'Gênero (separado por vírgulas)',
                    'Informe o gênero',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _resumoController,
                    'Resumo',
                    'Informe o resumo',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _imagemController,
                    'URL da imagem',
                    'Informe a URL da imagem',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _anolancController,
                    'Ano de lançamento (separado por /)',
                    'Informe o ano de lançamento',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _precoController,
                    'Preço',
                    'Informe o preço',
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    _nomepersController,
                    'Nome do personagem',
                    'Informe o nome do personagem',
                  ),
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
