class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String tipo;
  final String? cep;
  final String? cpf;
  final String? cidade;
  final String? rua;
  final String? numero;
  final String? bairro;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.tipo = 'usuario',
    this.cep,
    this.cpf,
    this.cidade,
    this.rua,
    this.numero,
    this.bairro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'tipo': tipo,
      'cep': cep,
      'cpf': cpf,
      'cidade': cidade,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      tipo: map['tipo'] ?? 'usuario',
      cep: map['cep'],
      cpf: map['cpf'],
      cidade: map['cidade'],
      rua: map['rua'],
      numero: map['numero'],
      bairro: map['bairro'],
    );
  }
}
