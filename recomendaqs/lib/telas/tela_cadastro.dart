import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmSenhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? nomeUsuario;

  Future<void> _cadastrarUsuario() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      User? user = userCredential.user;

      // Criar o documento na coleção "Users" com o UID do usuário
      await FirebaseFirestore.instance.collection('Users').doc(user?.uid).set({
        'HQsLidas': <String>[],
        'HQsFavoritas': <String>[],
        'UserHistorico': <String>[],
      });

      // Defina o nome de exibição
      await user?.updateProfile(displayName: usernameController.text);

      setState(() {
        nomeUsuario = user?.displayName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cadastro realizado com sucesso para $nomeUsuario.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, '/inicial');
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('O e-mail já está cadastrado.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

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
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/logo.png',
              height: 300,
              width: 500,
              fit: BoxFit.contain,
            ),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              width: double.infinity,
              height: 200,
              color: const Color(0xFF5653FF),
            ),
          ),
          
          // Imagem sobrepondo a onda
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/recomendaqs.png',
              height: 80, 
              width: 160, 
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                    controller: usernameController,
                    validator: (value) => _validateUsername(value!),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    labelText: 'Email',
                    controller: emailController,
                    validator: (value) => _validateEmail(value!),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    labelText: 'Senha',
                    controller: senhaController,
                    validator: (value) => _validateSenha(value!),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    labelText: 'Confirme sua Senha',
                    controller: confirmSenhaController,
                    validator: (value) => _validateConfirmSenha(value!),
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _cadastrarUsuario();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, corrija os campos destacados.',
                            ),
                          ),
                        );
                      }
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
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

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Digite um nome de usuário válido';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Digite um e-mail válido';
    }

    if (!value.contains('@')) {
      return 'O e-mail deve conter @';
    }

    if (value.length < 5) {
      return 'O e-mail deve ter pelo menos 5 caracteres';
    }

    return null;
  }

  String? _validateSenha(String value) {
    if (value.isEmpty) {
      return 'Digite uma senha válida';
    }

    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  String? _validateConfirmSenha(String value) {
    if (value != senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}
