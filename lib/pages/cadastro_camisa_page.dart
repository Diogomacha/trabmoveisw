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
  String? _tamanhoSelecionado;

  final List<String> _tamanhos = ['P', 'M', 'G', 'GG'];

  @override
  void initState() {
    super.initState();
    if (widget.camisaParaEditar != null) {
      _nomeController.text = widget.camisaParaEditar!.nome;
      _descricaoController.text = widget.camisaParaEditar!.descricao;
      _precoController.text = widget.camisaParaEditar!.preco.toStringAsFixed(2);
      _imagemSelecionada = widget.camisaParaEditar!.imagem;
      _tamanhoSelecionado = widget.camisaParaEditar!.tamanho;
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
        tamanho: _tamanhoSelecionado ?? 'M', // padrão se não for selecionado
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
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: const Icon(Icons.checkroom_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o nome da camisa';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite uma descrição';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(
                  labelText: 'Preço',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Digite o preço';
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null) return 'Digite um valor válido (ex: 39.90)';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tamanhoSelecionado,
                items: _tamanhos.map((tamanho) {
                  return DropdownMenuItem<String>(
                    value: tamanho,
                    child: Text('Tamanho $tamanho'),
                  );
                }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _tamanhoSelecionado = valor;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tamanho',
                  prefixIcon: const Icon(Icons.straighten),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null ? 'Selecione um tamanho' : null,
              ),
              const SizedBox(height: 24),
              ImagemPickerProduto(
                imagemPathInicial: _imagemSelecionada,
                onImageSelected: (String? path) {
                  setState(() {
                    _imagemSelecionada = path;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarCamisa,
                icon: Icon(isEditing ? Icons.save_outlined : Icons.check),
                label: Text(isEditing ? 'Salvar alterações' : 'Cadastrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
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
