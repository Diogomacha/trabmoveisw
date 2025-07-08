import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produtos.dart';
import '../controllers/carrinho_controller.dart';

class CarrinhoPage extends StatelessWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carrinho = context.watch<CarrinhoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
        elevation: 4,
      ),
      body: carrinho.itens.isEmpty
          ? Center(
        child: Text(
          'Seu carrinho está vazio',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: carrinho.itens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = carrinho.itens[index];
          final totalItem = item.camisa.preco * item.quantidade;

          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(item.camisa.imagem),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.camisa.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tamanho: ${item.camisa.tamanho ?? 'N/A'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Preço unitário: R\$ ${item.camisa.preco.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () =>
                                  carrinho.decrementarQuantidade(item.camisa),
                              color: Colors.redAccent,
                              tooltip: 'Diminuir quantidade',
                            ),
                            Text(
                              '${item.quantidade}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  carrinho.incrementarQuantidade(item.camisa),
                              color: Colors.green,
                              tooltip: 'Aumentar quantidade',
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              tooltip: 'Remover item',
                              onPressed: () => carrinho.remover(item.camisa),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${totalItem.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: carrinho.itens.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            carrinho.limpar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Compra finalizada!')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Finalizar Compra - Total R\$ ${carrinho.total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
