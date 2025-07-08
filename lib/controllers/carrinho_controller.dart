import 'package:flutter/material.dart';
import '../models/produtos.dart';

class CarrinhoItem {
  final Camisa camisa;
  int quantidade;

  CarrinhoItem({required this.camisa, this.quantidade = 1});
}

class CarrinhoController extends ChangeNotifier {
  final List<CarrinhoItem> _itens = [];

  List<CarrinhoItem> get itens => List.unmodifiable(_itens);

  double get total {
    double soma = 0;
    for (var item in _itens) {
      soma += item.camisa.preco * item.quantidade;
    }
    return soma;
  }

  void adicionarCamisa(Camisa camisa) {

    final index = _itens.indexWhere((item) =>
    item.camisa.id == camisa.id && item.camisa.tamanho == camisa.tamanho);

    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CarrinhoItem(camisa: camisa));
    }
    notifyListeners();
  }

  void remover(Camisa camisa) {
    _itens.removeWhere((item) =>
    item.camisa.id == camisa.id && item.camisa.tamanho == camisa.tamanho);
    notifyListeners();
  }

  void incrementarQuantidade(Camisa camisa) {
    final index = _itens.indexWhere((item) =>
    item.camisa.id == camisa.id && item.camisa.tamanho == camisa.tamanho);
    if (index >= 0) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void decrementarQuantidade(Camisa camisa) {
    final index = _itens.indexWhere((item) =>
    item.camisa.id == camisa.id && item.camisa.tamanho == camisa.tamanho);
    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
      notifyListeners();
    }
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }
}
