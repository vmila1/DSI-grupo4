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
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

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
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
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
        const SizedBox(height: 16.0),
        _buildTextField('Confirmar Nova Senha', confirmNewPasswordController),
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
        fillColor: Colors.grey[300],
      ),
    );
  }

  Future<void> _startEmailVerificationAndChangeEmail() async {
    if (_currentUser != null) {
      try {
        // Validações de e-mail e senha
        if (!isValidEmail(emailController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, forneça um e-mail válido.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!isValidPassword(currentPasswordController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Senha atual inválida.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

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
        // Verifica o tipo de erro
        if (error is FirebaseAuthException) {
          // Exibe uma mensagem específica para o erro de senha incorreta
          if (error.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Senha atual incorreta. Por favor, tente novamente.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        // Exibe uma mensagem genérica para outros erros
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
        // Validação de senha
        if (!isValidPassword(currentPasswordController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Senha atual inválida.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!isValidPassword(newPasswordController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Por favor, forneça uma nova senha válida (mínimo 6 caracteres).'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (newPasswordController.text != confirmNewPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'As senhas da nova senha e confirmar senha não coincidem.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

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
        // Verifica o tipo de erro
        if (error is FirebaseAuthException) {
          // Exibe uma mensagem específica para o erro de senha incorreta
          if (error.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Senha atual incorreta. Por favor, tente novamente.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        // Exibe uma mensagem genérica para outros erros
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao redefinir a senha'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool isValidEmail(String email) {
    // ignore: unnecessary_null_comparison
    return email != null &&
        email.isNotEmpty &&
        email.contains('@') &&
        email.length >= 6;
  }

  bool isValidPassword(String password) {
    // ignore: unnecessary_null_comparison
    return password != null && password.isNotEmpty && password.length >= 6;
  }
}
