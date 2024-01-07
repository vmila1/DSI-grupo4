import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfiguracaoConta extends StatefulWidget {
  const ConfiguracaoConta({Key? key}) : super(key: key);

  @override
  _ConfiguracaoContaState createState() => _ConfiguracaoContaState();
}

class _ConfiguracaoContaState extends State<ConfiguracaoConta> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
        emailController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações da Conta'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/perfil');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailSection(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _startEmailVerificationAndChangeEmail();
              },
              child: Text('Alterar E-mail'),
            ),
            SizedBox(height: 32.0),
            _buildPasswordSection(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _reauthenticateAndChangePassword();
              },
              child: Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('Novo E-mail', emailController),
        SizedBox(height: 16.0),
        _buildTextField('Senha Atual', currentPasswordController),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('Senha Atual', currentPasswordController),
        SizedBox(height: 16.0),
        _buildTextField('Nova Senha', newPasswordController),
      ],
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: labelText.contains('Senha'),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<void> _startEmailVerificationAndChangeEmail() async {
    if (_currentUser != null) {
      try {
        // Solicita que o usuário digite novamente sua senha para reautenticação
        String senha = currentPasswordController.text;
        AuthCredential credencial = EmailAuthProvider.credential(
          email: _currentUser!.email!,
          password: senha,
        );

        // Reautentica o usuário com as credenciais fornecidas
        await _currentUser!.reauthenticateWithCredential(credencial);

        // Atualiza o e-mail e envia a verificação
        await _currentUser!.updateEmail(emailController.text);
        await _currentUser!.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'E-mail de verificação enviado. Por favor, verifique seu e-mail antes de continuar.'),
            backgroundColor: Colors.yellow,
          ),
        );

        // Adicione um atraso antes de verificar o status da verificação de e-mail
        await Future.delayed(Duration(seconds: 15));

        // Recarrega o usuário para obter o status de verificação de e-mail atualizado
        await _currentUser!.reload();

        if (_currentUser!.emailVerified) {
          _loadUserData();
          print('Alteração de e-mail concluída com sucesso.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alteração de e-mail concluída com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('O novo e-mail ainda não foi verificado.');
        }
      } catch (error) {
        print('Erro ao iniciar a alteração de e-mail: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao iniciar a alteração de e-mail: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reauthenticateAndChangePassword() async {
    if (_currentUser != null) {
      try {
        // Reautenticar usuário com as credenciais atuais
        AuthCredential credential = EmailAuthProvider.credential(
          email: _currentUser!.email!,
          password: currentPasswordController.text,
        );
        await _currentUser!.reauthenticateWithCredential(credential);

        // Atualizar a senha
        await _currentUser!.updatePassword(newPasswordController.text);

        _loadUserData();
        print('Senha redefinida com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Senha redefinida com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        print('Erro ao reautenticar ou redefinir a senha: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao redefinir a senha'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
