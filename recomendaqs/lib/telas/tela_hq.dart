import 'package:flutter/material.dart';
import 'dart:ui';

class HqPage extends StatefulWidget {
  const HqPage({Key? key}) : super(key: key);

  @override
  _HqPageState createState() => _HqPageState();
}

class _HqPageState extends State<HqPage> {
  int totalImagens = 9;
  String nomeQuadrinho = "Os Vingadores: Kang e o seu momento perdido";
  String generoQuadrinho = "Gênero";
  String produtoraQuadrinho = "Produtora";
  String nomePersonagem = "Vingadores";
  String preco = "0.0";
  String avaliacao = "0.0";
  String resumo =
      "RESUMO: “A estrela. O ícone. A bruxa. O Construto. O Deus. O engenheiro. O rei. O mundo está sempre em perigo, e uma nova equipe de Vingadores se mobiliza para enfrentar quaisquer perigos que ousem ameaçar o planeta. Mas quando Terminus ataca, um novo e insidioso perigo surge: um que os Vingadores conhecem muito bem e que vem a eles na mais perigosa das formas – a de um amigo.“";

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(86, 83, 255, 1),
        title: Text('$generoQuadrinho'
            ' | '
            '$nomePersonagem'
            ' | '
            '$produtoraQuadrinho'),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/imagemhq.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: const Color.fromARGB(97, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      '$nomeQuadrinho',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/imagemhq.jpg',
                      height: 300,
                      width: 250,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 5),
                        Text(
                          '$avaliacao',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 60),
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 5),
                        Text(
                          '$preco',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Resumo: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '$resumo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Lógica
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    backgroundColor: Colors.white54,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text('Favoritar'),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Lógica
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    backgroundColor: Colors.white54,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.bookmark, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text('Não Lido'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _textEditingController,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
