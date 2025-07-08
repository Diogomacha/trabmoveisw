import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/produtos.dart';
import '../persistence/camisa_dao.dart';
import '../widgets/produto_card.dart';
import '../widgets/menu_usuario.dart';

class ProdutoUsuarioPage extends StatefulWidget {
  final Usuario usuario;

  const ProdutoUsuarioPage({Key? key, required this.usuario}) : super(key: key);

  @override
  State<ProdutoUsuarioPage> createState() => _ProdutoUsuarioPageState();
}

class _ProdutoUsuarioPageState extends State<ProdutoUsuarioPage> {
  int _indiceSelecionado = 0;
  List<Camisa> camisas = [];

  @override
  void initState() {
    super.initState();
    _carregarCamisas();
  }

  Future<void> _carregarCamisas() async {
    final lista = await CamisaDao().listarCamisas();
    setState(() {
      camisas = lista;
    });
  }

  void _aoSelecionarMenu(int index) {
    setState(() {
      _indiceSelecionado = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/perfil', arguments: widget.usuario);
        break;
      case 1:
        Navigator.pushNamed(context, '/pedidos');
        break;
      case 2:
        Navigator.pushNamed(context, '/carrinho');
        break;
      case 3:
        Navigator.pushNamed(context, '/contato');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'SPORTS+',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: camisas.isEmpty
            ? Center(
          child: Text(
            'Nenhuma camisa disponível',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : GridView.builder(
          itemCount: camisas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final camisa = camisas[index];
            return CamisaCard(camisa: camisa);
          },
        ),
      ),
      bottomNavigationBar: MenuUsuario(
        indiceSelecionado: _indiceSelecionado,
        aoSelecionar: _aoSelecionarMenu,
      ),
    );
  }
}
