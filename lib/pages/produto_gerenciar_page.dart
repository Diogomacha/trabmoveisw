import 'dart:io';
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
    if (resultado == true) _carregarCamisas();
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
        Navigator.pushReplacementNamed(context, '/cadastro');
        break;
      case 2:

        break;
    }
  }

  ImageProvider _getImage(String caminho) {
    if (caminho.startsWith('/')) {
      return FileImage(File(caminho));
    } else if (caminho.startsWith('http')) {
      return NetworkImage(caminho);
    } else {
      return AssetImage(caminho);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Camisas'),
        backgroundColor: Colors.green[700],
        elevation: 4,
      ),
      body: camisas.isEmpty
          ? Center(
        child: Text(
          'Nenhuma camisa cadastrada.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: camisas.length,
        itemBuilder: (context, index) {
          final camisa = camisas[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image(
                  image: _getImage(camisa.imagem),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 70, color: Colors.grey),
                ),
              ),
              title: Text(
                camisa.nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                camisa.precoFormatado,
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 28),
                    tooltip: 'Editar',
                    onPressed: () => _editarCamisa(camisa),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                    tooltip: 'Excluir',
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
