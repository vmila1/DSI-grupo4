import 'package:flutter/material.dart';
import 'package:recomendaqs/lib/telas/tela_Cadastro.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);

    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.5);
    final secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  String email = '';
  String senha = '';
  String username = '';
  String confirmSenha = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF5653FF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Cadastro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  labelText: 'Nome de Usuário',
                  onChanged: (text) {
                    username = text;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  labelText: 'Email',
                  onChanged: (text) {
                    email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  labelText: 'Senha',
                  onChanged: (text) {
                    senha = text;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  labelText: 'Confirme sua Senha',
                  onChanged: (text) {
                    confirmSenha = text;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inicial');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5653FF),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'Já tem uma conta? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'Clique aqui',
                          style: TextStyle(
                            color: Color(0xFF90FF02),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required String labelText,
    required void Function(String) onChanged,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}
