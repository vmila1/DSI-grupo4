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
  late List<String> hqsLidas;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _loadHqsLidas();
  }

  Future<void> _loadHqsLidas() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(_user.uid).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      setState(() {
        hqsLidas = List<String>.from(data['HQsLidas'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: const Text('HQs Lidas'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          hqsLidas.isNotEmpty
              ? ImagensHQ(hqsLidas: hqsLidas)
              : const Center(
                  // Mostra a mensagem quando não há HQs lidas
                  child: Text('Sem HQs marcadas como Lidas'),
                ),
        ],
      ),
    );
  }
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