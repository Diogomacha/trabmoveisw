import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produtos.dart';
import '../controllers/carrinho_controller.dart';

class CamisaDetalhe extends StatefulWidget {
  final Camisa camisa;

  const CamisaDetalhe({Key? key, required this.camisa}) : super(key: key);

  @override
  State<CamisaDetalhe> createState() => _CamisaDetalheState();
}

class _CamisaDetalheState extends State<CamisaDetalhe> {
  final List<String> _tamanhos = ['P', 'M', 'G', 'GG'];
  String? _tamanhoSelecionado;

  ImageProvider<Object> _resolverImagem(String caminho) {
    if (caminho.startsWith('/')) {
      return FileImage(File(caminho));
    } else if (caminho.startsWith('http')) {
      return NetworkImage(caminho);
    } else {
      return AssetImage(caminho);
    }
  }

  @override
  void initState() {
    super.initState();
    _tamanhoSelecionado = widget.camisa.tamanho ?? 'M';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: _resolverImagem(widget.camisa.imagem),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 220, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              widget.camisa.descricao,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.camisa.precoFormatado,
              style: TextStyle(
                fontSize: 22,
                color: Colors.green[800],
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _tamanhoSelecionado,
              items: _tamanhos.map((tamanho) {
                return DropdownMenuItem(
                  value: tamanho,
                  child: Text('Tamanho $tamanho'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tamanhoSelecionado = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Selecione o Tamanho',
                prefixIcon: const Icon(Icons.straighten),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) => value == null ? 'Selecione um tamanho' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_tamanhoSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selecione um tamanho')),
                  );
                  return;
                }

                final camisaComTamanho = widget.camisa.copyWith(
                  tamanho: _tamanhoSelecionado!,
                );

                context.read<CarrinhoController>().adicionarCamisa(camisaComTamanho);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produto adicionado ao carrinho!')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text(
                'Adicionar ao Carrinho',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 5,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                foregroundColor: Colors.green[700],
              ),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
