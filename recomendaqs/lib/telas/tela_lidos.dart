import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

class LidoPage extends StatefulWidget {
  const LidoPage({super.key});

  @override
  _LidoPageState createState() => _LidoPageState();
}

class _LidoPageState extends State<LidoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late Future<List<String>> _hqsLidasFuture;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _hqsLidasFuture = _loadHqsLidas();
  }

  Future<List<String>> _loadHqsLidas() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_user.uid)
            .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      return List<String>.from(data['HQsLidas'] ?? []);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text(
          'HQs Lidas',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _hqsLidasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se os dados ainda estão sendo carregados, exiba a tela de carregamento
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            // Se ocorrer um erro, você pode exibir uma mensagem de erro aqui
            return Center(
              child: Text('Erro ao carregar HQs lidas.'),
            );
          } else if (snapshot.data!.isEmpty) {
            // Se não houver HQs lidas, exiba uma mensagem informando isso
            return Center(
              child: Text('Sem HQs marcadas como Lidas'),
            );
          } else {
            // Se houver HQs lidas, exiba a grade de imagens
            return Stack(
              children: [
                Image.asset(
                  'assets/images/telafundo.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                ImagensHQ(hqsLidas: snapshot.data!),
              ],
            );
          }
        },
      ),
    );
  }
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

class ImagensHQ extends StatelessWidget {
  final List<String> hqsLidas;

  const ImagensHQ({super.key, required this.hqsLidas});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 100 / 150,
      ),
      itemCount: hqsLidas.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        var hqDocumentName = hqsLidas[index];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('HQs')
              .doc(hqDocumentName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var hqData = snapshot.data!.data() as Map<String, dynamic>;
            var imagemHQ = hqData['imagem'] as String;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HqPage(
                      hqDocumentName: hqDocumentName,
                      imagemHQ: imagemHQ,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  imagemHQ,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
