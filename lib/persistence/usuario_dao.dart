import 'package:sqflite/sqflite.dart';
import '../core/app_database.dart';
import '../models/usuario.dart';

class UsuarioDao {
  static const String _tabela = 'usuarios';

  Future<void> inserirUsuario(Usuario usuario) async {
    final db = await AppDatabase.instance.database;

    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM $_tabela');
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    final tipoUsuario = count == 0 ? 'gerente' : 'usuario';

    final usuarioParaInserir = Usuario(
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      tipo: tipoUsuario,
      cep: usuario.cep,
      cpf: usuario.cpf,
      cidade: usuario.cidade,
      rua: usuario.rua,
      numero: usuario.numero,
      bairro: usuario.bairro,
    );

    await db.insert(_tabela, usuarioParaInserir.toMap());
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final db = await AppDatabase.instance.database;
    final resultado = await db.query(
      _tabela,
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) {
      return Usuario.fromMap(resultado.first);
    }
    return null;
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await AppDatabase.instance.database;
    final resultado = await db.query(_tabela);
    return resultado.map((mapa) => Usuario.fromMap(mapa)).toList();
  }

  Future<void> deletarUsuario(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      _tabela,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }
}
