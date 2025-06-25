import 'dart:io';
import 'package:flutter/material.dart';
import '../models/produtos.dart';

class CamisaDetalhe extends StatelessWidget {
  final Camisa camisa;

  const CamisaDetalhe({Key? key, required this.camisa}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image(
                image: _resolverImagem(camisa.imagem),
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 200),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              camisa.descricao,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              camisa.precoFormatado,
              style: TextStyle(
                fontSize: 20,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produto adicionado ao carrinho!')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Adicionar ao Carrinho'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

