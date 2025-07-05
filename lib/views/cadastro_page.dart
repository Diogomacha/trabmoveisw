import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../persistence/usuario_dao.dart';
import 'login_page.dart';

class CadastroPage extends StatefulWidget {
  final Usuario? usuarioParaEditar;

  const CadastroPage({super.key, this.usuarioParaEditar});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _usuarioDao = UsuarioDao();

  @override
  void initState() {
    super.initState();
    if (widget.usuarioParaEditar != null) {
      _nomeController.text = widget.usuarioParaEditar!.nome;
      _emailController.text = widget.usuarioParaEditar!.email;
      _senhaController.text = widget.usuarioParaEditar!.senha;
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final usuario = Usuario(
        id: widget.usuarioParaEditar?.id,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text.trim(),
        tipo: widget.usuarioParaEditar?.tipo ?? 'usuario',
      );

      if (widget.usuarioParaEditar == null) {
        await _usuarioDao.inserirUsuario(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
        );
      } else {
        await _usuarioDao.atualizarUsuario(usuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.usuarioParaEditar != null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(editando ? 'Editar Perfil' : 'Criar Conta'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe seu nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o e-mail' : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(editando ? 'Salvar Alterações' : 'Cadastrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
