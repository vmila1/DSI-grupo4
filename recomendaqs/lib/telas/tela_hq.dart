import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HQ Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HqPage(
        hqDocumentName: '',
        imagemHQ: 'assets/images/imagemhq.jpg',
      ),
    );
  }
}

class HqPage extends StatefulWidget {
  final String hqDocumentName;
  final String imagemHQ;

  const HqPage({Key? key, required this.hqDocumentName, required this.imagemHQ})
      : super(key: key);

  @override
  _HqPageState createState() => _HqPageState();
}

class _HqPageState extends State<HqPage> {
  String nomeQuadrinho = "Os Vingadores: Kang e o seu momento perdido";
  String generoQuadrinho = "Gênero";
  String produtoraQuadrinho = "Produtora";
  String nomePersonagem = "Vingadores";
  String preco = "0.0";
  String avaliacao = "0.0";
  String resumo =
      "“A estrela. O ícone. A bruxa. O Construto. O Deus. O engenheiro. O rei. "
      "O mundo está sempre em perigo, e uma nova equipe de Vingadores se mobiliza "
      "para enfrentar quaisquer perigos que ousem ameaçar o planeta. Mas quando "
      "Terminus ataca, um novo e insidioso perigo surge: um que os Vingadores "
      "conhecem muito bem e que vem a eles na mais perigosa das formas - a de um amigo.“";

  TextEditingController _textEditingController = TextEditingController();
  bool favorito = false;
  bool lido = false;

  List<Map<String, String>> comentarios = [
    {
      'avatar': 'assets/images/icone_perfil.jpg',
      'name': 'João',
      'chat': 'Quadrinho top demais',
      'time': '15:30',
    },
    {
      'avatar': 'assets/images/avatar.jpg',
      'name': 'Maria',
      'chat': 'Achei ruim',
      'time': '15:32',
    },
    {
      'avatar': 'assets/images/avatar2.jpg',
      'name': 'Pedro',
      'chat': 'Gostei! massa.',
      'time': '15:32',
    },
  ];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(86, 83, 255, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$generoQuadrinho | $nomePersonagem | $produtoraQuadrinho',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            widget.imagemHQ,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  nomeQuadrinho,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  widget.imagemHQ,
                  height: 250,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          favorito = !favorito;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 216, 216, 216),
                        onPrimary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(
                        favorito ? Icons.favorite : Icons.favorite_border,
                        size: 24,
                      ),
                      label: Text(
                        favorito ? 'Favoritado' : 'Favoritar',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 65, 64, 64),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          lido = !lido;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 216, 216, 216),
                        onPrimary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(
                        lido ? Icons.bookmark : Icons.bookmark_outline,
                        size: 24,
                      ),
                      label: Text(
                        lido ? 'Lido' : 'Marcar como lido',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 65, 64, 64),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  'Resumo:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$resumo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: comentarios.map((comentario) {
                      return _itemChats(
                        avatar: comentario['avatar']!,
                        name: comentario['name']!,
                        chat: comentario['chat']!,
                        time: comentario['time']!,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Avatar(
                        size: 40,
                        image: 'assets/images/avatar.jpg',
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Digite seu comentário...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChats({
    required String avatar,
    required String name,
    required String chat,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Avatar(
            margin: EdgeInsets.only(right: 15),
            size: 40,
            image: avatar,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                chat,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final double size;
  final dynamic image;
  final EdgeInsets margin;

  Avatar({this.image, this.size = 20, this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(image),
        ),
      ),
    );
  }
}
