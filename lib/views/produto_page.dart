import 'package:flutter/material.dart';
import '../models/produtos.dart';
import '../persistence/camisa_dao.dart';
import '../widgets/produto_card.dart';
import '../widgets/menu_inferior.dart';

class ProdutoPage extends StatefulWidget {
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

    if (index == 1) {

      _abrirCadastro();
    } else if (index == 2) {

      Navigator.pushNamed(context, '/gerenciar');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('SPORTS+'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: camisas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
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
