import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produtos.dart';
import '../pages/produto_detalhe.dart';
import '../controllers/carrinho_controller.dart';

class CamisaCard extends StatelessWidget {
  final Camisa camisa;

  const CamisaCard({Key? key, required this.camisa}) : super(key: key);

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CamisaDetalhe(camisa: camisa),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shadowColor: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image(
                image: _resolverImagem(camisa.imagem),
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      camisa.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      camisa.precoFormatado,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        final carrinho = context.read<CarrinhoController>();
                        carrinho.adicionar(camisa);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Adicionado ao carrinho!')),
                        );
                      },
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      label: const Text('Adicionar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
