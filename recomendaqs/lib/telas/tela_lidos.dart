import 'package:flutter/material.dart';

class LidoPage extends StatefulWidget {
  const LidoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LidoPageState createState() => _LidoPageState();
}

class _LidoPageState extends State<LidoPage> {
  int totalImagens = 9;

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
          const ImagensHQ(),
        ],
      ),
    );
  }
}

class ImagensHQ extends StatelessWidget {
  const ImagensHQ({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
