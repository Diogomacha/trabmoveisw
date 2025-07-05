import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../persistence/usuario_dao.dart';
import 'cadastro_page.dart';
import 'produto_page.dart';
import 'produto_usuario_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _usuarioDao = UsuarioDao();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final usuario = await _usuarioDao.autenticar(
        _emailController.text.trim(),
        _senhaController.text.trim(),
      );

      if (usuario != null) {
        if (usuario.tipo == 'gerente') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProdutoPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProdutoUsuarioPage(usuario: usuario)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("E-mail ou senha inválidos")),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe o e-mail' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro_usuario');
                },
                child: const Text('Criar nova conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
