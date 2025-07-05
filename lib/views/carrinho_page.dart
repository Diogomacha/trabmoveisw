import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ),
      body: carrinho.itens.isEmpty
          ? const Center(child: Text('Carrinho vazio'))
          : ListView.builder(
        itemCount: carrinho.itens.length,
        itemBuilder: (context, index) {
          final item = carrinho.itens[index];
          final totalItem = item.camisa.preco * item.quantidade;

          return ListTile(
            leading: Image.file(
              File(item.camisa.imagem),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item.camisa.nome),
            subtitle: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => carrinho.decrementarQuantidade(item.camisa),
                ),
                Text('${item.quantidade}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => carrinho.incrementarQuantidade(item.camisa),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('R\$ ${totalItem.toStringAsFixed(2)}'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => carrinho.remover(item.camisa),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: carrinho.itens.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            carrinho.limpar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Compra finalizada!')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text(
            'Finalizar Compra - Total R\$ ${carrinho.total.toStringAsFixed(2)}',
          ),
        ),
      ),
    );
  }
}
