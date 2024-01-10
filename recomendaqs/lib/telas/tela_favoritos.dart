import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

class FavoritoPage extends StatefulWidget {
  const FavoritoPage({Key? key}) : super(key: key);

  @override
  _FavoritoPageState createState() => _FavoritoPageState();
}

class _FavoritoPageState extends State<FavoritoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late List<String> hqsFavoritas;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadHqsFavoritas();
  }

  Future<void> _loadHqsFavoritas() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(_user.uid).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        hqsFavoritas = List<String>.from(data['HQsFavoritas'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: const Text('HQs Favoritas'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          hqsFavoritas.isNotEmpty
              ? ImagensHQ(hqsFavoritas: hqsFavoritas)
              : const Center(
                  // Mostra a mensagem quando não há HQs favoritadas
                  child: Text('Sem HQs marcadas como Favoritas'),
                ),
        ],
      ),
    );
  }
}

class ImagensHQ extends StatelessWidget {
  final List<String> hqsFavoritas;

  const ImagensHQ({Key? key, required this.hqsFavoritas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 100 / 150,
      ),
      itemCount: hqsFavoritas.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        var hqDocumentName = hqsFavoritas[index];

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('HQs').doc(hqDocumentName).snapshots(),
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