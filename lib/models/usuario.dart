class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String tipo;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.tipo = 'usuario',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      tipo: map['tipo'] ?? 'usuario',
    );
  }
}
