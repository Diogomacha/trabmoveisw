import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../persistence/usuario_dao.dart';
import 'login_page.dart';
import 'cadastro_page.dart';

class PerfilPage extends StatefulWidget {
  final Usuario usuario;

  const PerfilPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final UsuarioDao _usuarioDao = UsuarioDao();
  late Usuario _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  Future<void> _confirmarExclusao() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir sua conta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmacao == true) {
      await _usuarioDao.deletarUsuario(_usuario.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  void _editarPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroPage(usuarioParaEditar: _usuario),
      ),
    ).then((_) async {

      final atualizado = await _usuarioDao.autenticar(_usuario.email, _usuario.senha);
      if (atualizado != null) {
        setState(() {
          _usuario = atualizado;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            Text('Nome: ${_usuario.nome}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text('E-mail: ${_usuario.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _editarPerfil,
              icon: const Icon(Icons.edit),
              label: const Text('Editar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _confirmarExclusao,
              icon: const Icon(Icons.delete),
              label: const Text('Excluir Conta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
