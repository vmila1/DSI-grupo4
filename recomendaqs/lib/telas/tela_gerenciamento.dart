import 'package:flutter/material.dart';
import 'package:recomendaqs/telas/tela_addhq.dart';

class TelaGerenciaHq extends StatefulWidget {
  const TelaGerenciaHq({Key? key}) : super(key: key);

  @override
  _TelaGerenciaHqState createState() => _TelaGerenciaHqState();
}

class _TelaGerenciaHqState extends State<TelaGerenciaHq> {
  List<String> minhasHQs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Text('Minhas HQs'),
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
            MaterialPageRoute(builder: (context) => TelaAddHq()),
          );

          if (novoHQ != null && novoHQ is String) {
            setState(() {
              minhasHQs.add(novoHQ);
            });
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
        return ListTile(
          title: Text(minhasHQs[index]),
        );
      },
    );
  }
}


