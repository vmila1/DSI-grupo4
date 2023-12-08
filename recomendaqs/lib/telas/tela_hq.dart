import 'package:flutter/material.dart';
import 'dart:ui';

class HqPage extends StatefulWidget {
  const HqPage({Key? key}) : super(key: key);

  @override
  _HqPageState createState() => _HqPageState();
}

class _HqPageState extends State<HqPage> {
  int totalImagens = 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(86, 83, 255, 1),
        title: Text('Gênero | Nome | Produtora'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/imagemhq.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(97, 0, 0, 0),
              ),
              child: Center(
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


