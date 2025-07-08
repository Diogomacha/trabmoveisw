import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final _cpfController = TextEditingController();
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();

  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  final _usuarioDao = UsuarioDao();

  @override
  void initState() {
    super.initState();
    if (widget.usuarioParaEditar != null) {
      final u = widget.usuarioParaEditar!;
      _nomeController.text = u.nome;
      _emailController.text = u.email;
      _senhaController.text = u.senha;
      _cpfController.text = u.cpf ?? '';
      _cepController.text = u.cep ?? '';
      _cidadeController.text = u.cidade ?? '';
      _ruaController.text = u.rua ?? '';
      _numeroController.text = u.numero ?? '';
      _bairroController.text = u.bairro ?? '';
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
        cpf: _cpfController.text.trim(),
        cep: _cepController.text.trim(),
        cidade: _cidadeController.text.trim(),
        rua: _ruaController.text.trim(),
        numero: _numeroController.text.trim(),
        bairro: _bairroController.text.trim(),
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
        title: Text(editando ? 'Editar perfil' : 'Criar conta'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Icon(editando ? Icons.edit : Icons.person_add, size: 72, color: Colors.green),
                const SizedBox(height: 16),
                Text(
                  editando ? "Editar seu perfil" : "Crie sua conta",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 32),

                // Campos principais
                _campo(_nomeController, 'Nome', Icons.person_outline),
                const SizedBox(height: 16),
                _campo(_emailController, 'E-mail', Icons.email_outlined),
                const SizedBox(height: 16),
                _campoSenha(),
                const SizedBox(height: 16),
                _campo(_cpfController, 'CPF', Icons.badge, formatter: _cpfFormatter),
                const SizedBox(height: 16),
                _campo(_cepController, 'CEP', Icons.location_on, formatter: _cepFormatter),
                const SizedBox(height: 16),
                _campo(_cidadeController, 'Cidade', Icons.location_city),
                const SizedBox(height: 16),
                _campo(_bairroController, 'Bairro', Icons.map),
                const SizedBox(height: 16),
                _campo(_ruaController, 'Rua', Icons.route),
                const SizedBox(height: 16),
                _campo(_numeroController, 'Número', Icons.pin),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _salvar,
                  child: Text(
                    editando ? 'Salvar alterações' : 'Cadastrar',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController controller, String label, IconData icon,
      {MaskTextInputFormatter? formatter}) {
    return TextFormField(
      controller: controller,
      inputFormatters: formatter != null ? [formatter] : [],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Digite $label' : null,
    );
  }

  Widget _campoSenha() {
    return TextFormField(
      controller: _senhaController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Digite uma senha' : null,
    );
  }
}
