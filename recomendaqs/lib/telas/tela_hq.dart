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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(86, 83, 255, 1),
        title: Text('Gênero | Nome | Produtora'),
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
                        fontSize: 24,
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
