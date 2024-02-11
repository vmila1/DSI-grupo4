import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

enum OrderBy { nome, precoAsc, precoDesc }

class FavoritoPage extends StatefulWidget {
  const FavoritoPage({Key? key}) : super(key: key);

  @override
  _FavoritoPageState createState() => _FavoritoPageState();
}

class _FavoritoPageState extends State<FavoritoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late Future<List<Map<String, dynamic>>> _hqsFavoritasFuture;
  TextEditingController _searchController = TextEditingController();
  OrderBy _orderBy = OrderBy.nome; // Ordenação padrão por nome

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _hqsFavoritasFuture = _loadHqsFavoritas();
  }

  Future<List<Map<String, dynamic>>> _loadHqsFavoritas() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_user.uid)
            .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      List<String> hqsFavoritasIds =
          List<String>.from(data['HQsFavoritas'] ?? []);
      List<Map<String, dynamic>> hqsFavoritas = [];

      // Obtém as informações das HQs favoritas usando os IDs
      for (String hqId in hqsFavoritasIds) {
        DocumentSnapshot<Map<String, dynamic>> hqSnapshot =
            await FirebaseFirestore.instance.collection('HQs').doc(hqId).get();
        if (hqSnapshot.exists) {
          var hqData = hqSnapshot.data();
          if (hqData != null && hqData['nomeQuadrinho'] != null) {
            hqsFavoritas.add({
              'id': hqId,
              'nome': hqData['nomeQuadrinho'],
              'preco': hqData['preco'],
            });
          }
        }
      }

      return hqsFavoritas;
    } else {
      return [];
    }
  }

  void _adicionarNovaHQ() async {
    // Obtém a lista total de HQs da coleção 'HQs'
    final QuerySnapshot<Map<String, dynamic>> hqsQuerySnapshot =
        await FirebaseFirestore.instance.collection('HQs').get();

    // Extrai os nomes e IDs das HQs da lista total
    List<Map<String, dynamic>> todasHqs = hqsQuerySnapshot.docs
        .map((doc) => {'id': doc.id, 'nome': doc['nomeQuadrinho']})
        .toList();

    // Obtém a lista de HQs favoritas do usuário
    final userDocSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.uid)
        .get();
    List<String> hqsFavoritas =
        List<String>.from(userDocSnapshot.get('HQsFavoritas') ?? []);

    // Remove as HQs favoritas da lista total para obter as HQs disponíveis
    List<Map<String, dynamic>> hqsDisponiveis =
        todasHqs.where((hq) => !hqsFavoritas.contains(hq['id'])).toList();

    // Abre um diálogo para o usuário selecionar a HQ a ser adicionada
    Map<String, dynamic>? hqSelecionada =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar HQ aos Favoritos'),
          content: SingleChildScrollView(
            child: ListBody(
              children: hqsDisponiveis.map((hq) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      hq['nome'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(hq);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    // Se o usuário selecionar uma HQ, adiciona à lista de favoritos
    if (hqSelecionada != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(_user.uid);
      await userDocRef.update({
        'HQsFavoritas': FieldValue.arrayUnion([hqSelecionada['id']]),
      });

      setState(() {
        _hqsFavoritasFuture = _loadHqsFavoritas();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ adicionada à lista de favoritos.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _removerHQ(String hqDocumentName) async {
    bool? confirmacao = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Remoção'),
          content:
              Text('Tem certeza de que deseja remover esta HQ dos favoritos?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmação
              },
              child: Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );

    if (confirmacao != null && confirmacao) {
      // Remove a HQ da lista de favoritos do usuário
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(_user.uid);
      await userDocRef.update({
        'HQsFavoritas': FieldValue.arrayRemove([hqDocumentName]),
      });
      setState(() {
        _hqsFavoritasFuture = _loadHqsFavoritas();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ removida da lista de favoritos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _filteredHQs(
      List<Map<String, dynamic>> hqs, String searchTerm) {
    if (searchTerm.isEmpty) {
      hqs.sort((a, b) {
        if (_orderBy == OrderBy.nome) {
          return a['nome'].compareTo(b['nome']);
        } else if (_orderBy == OrderBy.precoAsc) {
          return a['preco'].compareTo(b['preco']);
        } else if (_orderBy == OrderBy.precoDesc) {
          return b['preco'].compareTo(a['preco']);
        } else {
          return 0;
        }
      });
      return hqs;
    }
    return hqs.where((hq) {
      return hq['nome'].toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text(
          'HQs Favoritas',
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
        future: _hqsFavoritasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se os dados ainda estão sendo carregados, exiba a tela de carregamento
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            // Se ocorrer um erro, você pode exibir uma mensagem de erro aqui
            return Center(
              child: Text('Erro ao carregar HQs favoritas.'),
            );
          } else if (snapshot.data!.isEmpty) {
            // Se não houver HQs favoritas, exiba uma mensagem informando isso
            return Center(
              child: Text(
                'Sem HQs marcadas como Favoritas',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            // Se houver HQs favoritas, exiba a grade de imagens
            return Stack(
              children: [
                Image.asset(
                  'assets/images/telafundo.png',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                ImagensHQ(hqsFavoritas: snapshot.data!),
              ],
            );
          }
        },
      ),
    );
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/telafundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
