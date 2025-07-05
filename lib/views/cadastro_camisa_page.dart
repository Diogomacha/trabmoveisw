import 'package:flutter/material.dart';
import '../models/produtos.dart';
import '../persistence/camisa_dao.dart';
import '../widgets/menu_inferior.dart';
import '../widgets/imagem_picker_produto.dart';

class CadastroCamisaPage extends StatefulWidget {
  final Camisa? camisaParaEditar;

  const CadastroCamisaPage({Key? key, this.camisaParaEditar}) : super(key: key);

  @override
  State<CadastroCamisaPage> createState() => _CadastroCamisaPageState();
}

class _CadastroCamisaPageState extends State<CadastroCamisaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  int _indiceSelecionado = 1;
  String? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    if (widget.camisaParaEditar != null) {
      _nomeController.text = widget.camisaParaEditar!.nome;
      _descricaoController.text = widget.camisaParaEditar!.descricao;
      _precoController.text = widget.camisaParaEditar!.preco.toStringAsFixed(2);
      _imagemSelecionada = widget.camisaParaEditar!.imagem;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _salvarCamisa() async {
    if (_formKey.currentState!.validate()) {
      final precoCorrigido = double.parse(_precoController.text.replaceAll(',', '.'));

      final novaCamisa = Camisa(
        id: widget.camisaParaEditar?.id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        preco: precoCorrigido,
        imagem: _imagemSelecionada ?? '',
      );

      if (widget.camisaParaEditar == null) {
        await CamisaDao().inserirCamisa(novaCamisa);
      } else {
        await CamisaDao().atualizarCamisa(novaCamisa);
      }

      Navigator.pop(context, true);
    }
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
        Navigator.pushReplacementNamed(context, '/gerenciar');
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.camisaParaEditar != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Camisa' : 'Cadastrar Camisa'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o nome';
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a descrição';
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o preço';
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null) return 'Digite um número válido (ex: 30.00)';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ImagemPickerProduto(
                imagemPathInicial: _imagemSelecionada,
                onImageSelected: (String? path) {
                  setState(() {
                    _imagemSelecionada = path;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarCamisa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(isEditing ? 'Salvar Alterações' : 'Cadastrar'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MenuInferior(
        indiceSelecionado: _indiceSelecionado,
        aoSelecionar: _aoSelecionarMenu,
      ),
    );
  }
}
