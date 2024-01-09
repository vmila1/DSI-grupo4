import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? nomeUsuario;

  bool loginError = false;
  String errorMessage = '';
  bool emailError = false;
  bool senhaError = false;

  Future<void> _realizarLogin() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      setState(() {
        nomeUsuario = userCredential.user?.displayName;
        loginError = false;
        errorMessage = '';
        emailError = false;
        senhaError = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login bem-sucedido. Bem-vindo, $nomeUsuario!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/inicial');
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Erro durante o login: $e');
      setState(() {
        loginError = true;
        emailError =
            e.code == 'invalid-email' || e.code == 'invalid-credential';
        senhaError = e.code == 'invalid-credential';
        switch (e.code) {
          case 'wrong-password':
            errorMessage = 'Senha incorreta. Tente novamente.';
            break;
          case 'user-not-found':
            errorMessage = 'Email não encontrado. Tente novamente.';
            break;
          case 'invalid-email':
            errorMessage =
                'O Email está mal formatado. Corrija-o e tente novamente.';
            break;
          case 'invalid-credential':
            errorMessage =
                'Email ou senha inválido. Verifique suas credenciais.';
            break;
          case 'too-many-requests':
            senhaError = false;
            errorMessage =
                'Muitas tentativas de login. Tente novamente mais tarde.';
            break;
          default:
            errorMessage = 'Falha no login. Verifique suas credenciais.';
            break;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: "OK",
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );

      // Adicionando a janela flutuante (AlertDialog)
      if (loginError) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Falha no Login'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
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
                    'Bem vindo(a)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(
                      color: emailError ? Colors.red : Colors.grey,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: emailError ? Colors.red : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    style: TextStyle(
                      color: senhaError ? Colors.red : Colors.grey,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: senhaError ? Colors.red : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _realizarLogin();
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
                      'Entrar',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white), // Set text color to white
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Não é cadastrado? ',
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
}
