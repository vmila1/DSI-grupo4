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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
        title: const Text('Configurações da Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/perfil');
          },
        ),
        backgroundColor:
            Colors.blue, // Cor da barra de aplicativos
      ),
      body: Stack(
        children: [
          // Imagem de Fundo
          Image.asset(
            'assets/images/telafundo.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailSection(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _startEmailVerificationAndChangeEmail();
                  },
                  child: const Text('Alterar E-mail'),
                ),
                const SizedBox(height: 64.0),
                _buildPasswordSection(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _reauthenticateAndChangePassword();
                  },
                  child: const Text('Alterar Senha'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('Novo E-mail', emailController),
        const SizedBox(height: 16.0),
        _buildTextField('Senha Atual', currentPasswordController),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField('Senha Atual', currentPasswordController),
        const SizedBox(height: 16.0),
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
        border: const OutlineInputBorder(),
        filled: true,
        fillColor:
            Colors.grey[300], // Defina a cor desejada para a caixa de texto
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
          const SnackBar(
            content: Text(
                'E-mail de verificação enviado. Por favor, verifique seu e-mail antes de continuar.'),
            backgroundColor: Colors.yellow,
          ),
        );

        // Atraso antes de verificar o status da verificação de e-mail
        await Future.delayed(const Duration(seconds: 15));

        // Recarrega o usuário para obter o status de verificação de e-mail atualizado
        await _currentUser!.reload();

        if (_currentUser!.emailVerified) {
          _loadUserData();
          // ignore: avoid_print
          print('Alteração de e-mail concluída com sucesso.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alteração de e-mail concluída com sucesso.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // ignore: avoid_print
          print('O novo e-mail ainda não foi verificado.');
        }
      } catch (error) {
        // ignore: avoid_print
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
        // ignore: avoid_print
        print('Senha redefinida com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha redefinida com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        // ignore: avoid_print
        print('Erro ao reautenticar ou redefinir a senha: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao redefinir a senha'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
