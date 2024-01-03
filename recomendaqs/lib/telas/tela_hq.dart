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

    return hqDocument;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da HQ'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: hqData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          var hqData = snapshot.data!.data()!;
          var generoQuadrinho =
              hqData['generoQuadrinho'] ?? 'Gênero não informado';

          // Converte o array de números para uma lista de strings
          var anosLancamento = (hqData['anoLançamento'] as List<dynamic>?)
                  ?.map((ano) => ano.toString())
                  ?.toList()
                  ?.join('/') ??
              'Não informado';

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hqData['nomeQuadrinho'] ?? 'Nome não informado',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Image.network(
                  hqData['imagem'] ?? '',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                SizedBox(height: 16.0),
                Text('Ano(s) de Lançamento: $anosLancamento'),
                Text('Avaliação: ${hqData['avaliacao'] ?? 'Não informado'}'),
                Text('Gênero: $generoQuadrinho'),
                Text('Preço: ${hqData['preco'] ?? 'Não informado'}'),
                Text('Resumo: ${hqData['resumo'] ?? 'Não informado'}'),
                // Adicione os outros campos conforme necessário
              ],
            ),
          );
        },
      ),
    );
  }
}
