import 'package:flutter/material.dart';
import '../models/produtos.dart';
import '../persistence/camisa_dao.dart';
import '../widgets/produto_card.dart';
import '../widgets/menu_inferior.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({Key? key}) : super(key: key);

  @override
  State<ProdutoPage> createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {
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

  Future<void> _abrirCadastro() async {
    await Navigator.pushNamed(context, '/cadastro');
    _carregarCamisas();
  }

  void _aoSelecionarMenu(int index) {
    setState(() {
      _indiceSelecionado = index;
    });

    switch (index) {
      case 1:
        _abrirCadastro();
        break;
      case 2:
        Navigator.pushNamed(context, '/gerenciar');
        break;
      default:
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
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
      bottomNavigationBar: MenuInferior(
        indiceSelecionado: _indiceSelecionado,
        aoSelecionar: _aoSelecionarMenu,
      ),
    );
  }
}
