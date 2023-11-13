import 'package:flutter/material.dart';

class FavoritoPage extends StatefulWidget {
  @override
  _FavoritoPageState createState() => _FavoritoPageState();
}

class _FavoritoPageState extends State<FavoritoPage> {
  int totalImagens = 9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(86, 83, 255, 1),
        title: Text('HQs Favoritas'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          ImagensHQ(),
        ],
      ),
    );
  }
}

class ImagensHQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 100 / 150,
      ),
      itemCount: 9,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/images/imagemhq.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        );
      },
    );
  }
}
