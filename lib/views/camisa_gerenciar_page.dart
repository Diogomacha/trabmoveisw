import 'package:flutter/material.dart';
import '../models/produtos.dart';
import '../persistence/camisa_dao.dart';
import 'cadastro_camisa_page.dart';
import '../widgets/menu_inferior.dart';

class CamisaGerenciarPage extends StatefulWidget {
  const CamisaGerenciarPage({Key? key}) : super(key: key);

  @override
  State<CamisaGerenciarPage> createState() => _CamisaGerenciarPageState();
}

class _CamisaGerenciarPageState extends State<CamisaGerenciarPage> {
  List<Camisa> camisas = [];
  int _indiceSelecionado = 2;

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

  void _editarCamisa(Camisa camisa) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroCamisaPage(camisaParaEditar: camisa),
      ),
    );

    if (resultado == true) {
      _carregarCamisas();
    }
  }

  void _excluirCamisa(int id) async {
    await CamisaDao().deletarCamisa(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Camisa excluída com sucesso")),
    );
    _carregarCamisas();
  }

  void _aoSelecionarMenu(int index) {
    setState(() {
      _indiceSelecionado = index;
    });


    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:

        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cadastro');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Camisas'),
        backgroundColor: Colors.green[700],
      ),
      body: camisas.isEmpty
          ? const Center(child: Text('Nenhuma camisa cadastrada.'))
          : ListView.builder(
        itemCount: camisas.length,
        itemBuilder: (context, index) {
          final camisa = camisas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: camisa.imagem.startsWith('http')
                    ? Image.network(
                  camisa.imagem,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 60),
                )
                    : Image.asset(
                  camisa.imagem,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(camisa.nome),
              subtitle: Text(
                camisa.precoFormatado,
                style: const TextStyle(color: Colors.green),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarCamisa(camisa),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _excluirCamisa(camisa.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: MenuInferior(
        indiceSelecionado: _indiceSelecionado,
        aoSelecionar: _aoSelecionarMenu,
      ),
    );
  }
}
