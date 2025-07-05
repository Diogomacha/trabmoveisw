import 'package:flutter/material.dart';
import '../models/carrinho_item.dart';
import '../models/produtos.dart';

class CarrinhoController extends ChangeNotifier {
  final List<CarrinhoItem> _itens = [];

  List<CarrinhoItem> get itens => _itens;

  void adicionar(Camisa camisa) {
    final index = _itens.indexWhere((item) => item.camisa.id == camisa.id);
    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CarrinhoItem(camisa: camisa));
    }
    notifyListeners();
  }

  void remover(Camisa camisa) {
    _itens.removeWhere((item) => item.camisa.id == camisa.id);
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    notifyListeners();
  }

  void incrementarQuantidade(Camisa camisa) {
    final index = _itens.indexWhere((item) => item.camisa.id == camisa.id);
    if (index >= 0) {
      _itens[index].quantidade++;
      notifyListeners();
    }
  }

  void decrementarQuantidade(Camisa camisa) {
    final index = _itens.indexWhere((item) => item.camisa.id == camisa.id);
    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get total {
    return _itens.fold(
      0,
          (total, item) => total + (item.camisa.preco * item.quantidade),
    );
  }
}
