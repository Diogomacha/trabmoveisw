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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
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

  Widget _campo(String label, String? valor) {
    if (valor == null || valor.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.account_circle, size: 100, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _campo('Nome', _usuario.nome),
              _campo('E-mail', _usuario.email),
              _campo('CPF', _usuario.cpf),
              _campo('CEP', _usuario.cep),
              _campo('Cidade', _usuario.cidade),
              _campo('Bairro', _usuario.bairro),
              _campo('Rua', _usuario.rua),
              _campo('Número', _usuario.numero),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _editarPerfil,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _confirmarExclusao,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Excluir Conta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
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
                  backgroundColor: Colors.grey[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
