import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendaqs/telas/tela_hq.dart';

enum OrderBy { nome, precoAsc, precoDesc }

class LidoPage extends StatefulWidget {
  const LidoPage({Key? key}) : super(key: key);

  @override
  _LidoPageState createState() => _LidoPageState();
}

class _LidoPageState extends State<LidoPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  late Future<List<Map<String, dynamic>>> _hqsLidasFuture;
  TextEditingController _searchController = TextEditingController();
  OrderBy _orderBy = OrderBy.nome; // Ordenação padrão por nome

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _hqsLidasFuture = _loadHqsLidas();
  }

  Future<List<Map<String, dynamic>>> _loadHqsLidas() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_user.uid)
            .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      List<String> hqsLidasIds = List<String>.from(data['HQsLidas'] ?? []);
      List<Map<String, dynamic>> hqsLidas = [];

      for (String hqId in hqsLidasIds) {
        DocumentSnapshot<Map<String, dynamic>> hqSnapshot =
            await FirebaseFirestore.instance.collection('HQs').doc(hqId).get();
        if (hqSnapshot.exists) {
          var hqData = hqSnapshot.data();
          if (hqData != null && hqData['nomeQuadrinho'] != null) {
            hqsLidas.add({
              'id': hqId,
              'nome': hqData['nomeQuadrinho'],
              'preco': hqData['preco'],
            });
          }
        }
      }

      return hqsLidas;
    } else {
      return [];
    }
  }

  void _adicionarNovaHQ() async {
    final QuerySnapshot<Map<String, dynamic>> hqsQuerySnapshot =
        await FirebaseFirestore.instance.collection('HQs').get();

    List<Map<String, dynamic>> todasHqs = hqsQuerySnapshot.docs
        .map((doc) => {'id': doc.id, 'nome': doc['nomeQuadrinho']})
        .toList();

    final userDocSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user.uid)
        .get();
    List<String> hqsLidas =
        List<String>.from(userDocSnapshot.get('HQsLidas') ?? []);

    List<Map<String, dynamic>> hqsDisponiveis =
        todasHqs.where((hq) => !hqsLidas.contains(hq['id'])).toList();

    Map<String, dynamic>? hqSelecionada =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar HQ às Lidas'),
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

    if (hqSelecionada != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(_user.uid);
      await userDocRef.update({
        'HQsLidas': FieldValue.arrayUnion([hqSelecionada['id']]),
      });

      setState(() {
        _hqsLidasFuture = _loadHqsLidas();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ adicionada à lista de lidos.'),
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
          content: Text('Tem certeza de que deseja remover esta HQ dos lidos?'),
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
      final userDocRef =
          FirebaseFirestore.instance.collection('Users').doc(_user.uid);
      await userDocRef.update({
        'HQsLidas': FieldValue.arrayRemove([hqDocumentName]),
      });
      setState(() {
        _hqsLidasFuture = _loadHqsLidas();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('HQ removida da lista de lidos.'),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: _adicionarNovaHQ,
          child: Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/telafundo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar HQ',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search,
                      color: Colors.black), // Ícone de lupa preto
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Ordenar por:',
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<OrderBy>(
                    value: _orderBy,
                    onChanged: (OrderBy? newValue) {
                      setState(() {
                        _orderBy = newValue!;
                      });
                    },
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.blue),
                    items: [
                      DropdownMenuItem(
                        value: OrderBy.nome,
                        child: Text(
                          'Nome',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      DropdownMenuItem(
                        value: OrderBy.precoAsc,
                        child: Text(
                          'Preço (Menor para Maior)',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      DropdownMenuItem(
                        value: OrderBy.precoDesc,
                        child: Text(
                          'Preço (Maior para Menor)',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _hqsLidasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingScreen();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar HQs lidas.'),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'Sem HQs marcadas como Lidas',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  } else {
                    List<Map<String, dynamic>> filteredHQs = _filteredHQs(
                      snapshot.data!,
                      _searchController.text,
                    );
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredHQs.length,
                        itemBuilder: (context, index) {
                          var hqData = filteredHQs[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hqData['nome'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'R\$ ${hqData['preco']}',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HqPage(
                                      hqDocumentName: hqData['id'],
                                      imagemHQ: '',
                                    ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  _removerHQ(hqData['id']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
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
