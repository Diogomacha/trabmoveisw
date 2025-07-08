import 'package:intl/intl.dart';

class Camisa {
  final int? id;
  final String nome;
  final String imagem;
  final String descricao;
  final double preco;
  final String? tamanho; // Novo campo

  Camisa({
    this.id,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.preco,
    this.tamanho,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'imagem': imagem,
      'descricao': descricao,
      'preco': preco,
      'tamanho': tamanho,
    };
  }

  factory Camisa.fromMap(Map<String, dynamic> map) {
    return Camisa(
      id: map['id'],
      nome: map['nome'],
      imagem: map['imagem'],
      descricao: map['descricao'],
      preco: map['preco'] is int
          ? (map['preco'] as int).toDouble()
          : map['preco'] is String
          ? double.tryParse(map['preco'].replaceAll(',', '.')) ?? 0.0
          : map['preco'] ?? 0.0,
      tamanho: map['tamanho'],
    );
  }

  Camisa copyWith({
    int? id,
    String? nome,
    String? imagem,
    String? descricao,
    double? preco,
    String? tamanho,
  }) {
    return Camisa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      imagem: imagem ?? this.imagem,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      tamanho: tamanho ?? this.tamanho,
    );
  }

  String get precoFormatado {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(preco);
  }
}
