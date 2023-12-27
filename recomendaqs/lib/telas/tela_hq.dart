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
      home: HqPage(),
    );
  }
}

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
      "“A estrela. O ícone. A bruxa. O Construto. O Deus. O engenheiro. O rei. "
      "O mundo está sempre em perigo, e uma nova equipe de Vingadores se mobiliza "
      "para enfrentar quaisquer perigos que ousem ameaçar o planeta. Mas quando " 
      "Terminus ataca, um novo e insidioso perigo surge: um que os Vingadores "
      "conhecem muito bem e que vem a eles na mais perigosa das formas - a de um amigo.“";

  TextEditingController _textEditingController = TextEditingController();
  bool favorito = false;
  bool lido = false;

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$generoQuadrinho | $nomePersonagem | $produtoraQuadrinho',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/imagemhq.jpg',
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
                SizedBox(height: 40), // Espaçamento no topo
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
                  'assets/images/imagemhq.jpg',
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
                _itemChats(
                  avatar: 'assets/images/avatar.jpg',
                  name: 'João',
                  chat: 'Quadrinho toppp demais',
                  time: '15:30',
                ),
                _itemChats(
                  avatar: 'assets/images/avatar.jpg',
                  name: 'Maria',
                  chat: 'Achei uma bosta',
                  time: '15:32',
                ),
                _itemChats(
                  avatar: 'assets/images/avatar.jpg',
                  name: 'Pedro',
                  chat: 'Gostei! massa.',
                  time: '15:32',
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

Widget _itemChats({
  String avatar = '',
  String name = '',
  String chat = '',
  String time = '00.00',
}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 5),
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
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
    ),
  );
}
