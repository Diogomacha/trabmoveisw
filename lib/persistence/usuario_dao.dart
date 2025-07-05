import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class UsuarioDao {
  static const String _tabela = 'usuarios';

  Future<Database> _abrirBanco() async {
    final caminhoBanco = await getDatabasesPath();
    return openDatabase(
      join(caminhoBanco, 'futebol_app.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_tabela (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL,
            tipo TEXT NOT NULL DEFAULT 'usuario'
          )
        ''');
      },
    );
  }

  Future<void> inserirUsuario(Usuario usuario) async {
    final db = await _abrirBanco();


    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM $_tabela');
    final count = Sqflite.firstIntValue(countResult) ?? 0;


    final tipoUsuario = count == 0 ? 'gerente' : 'usuario';

    final usuarioParaInserir = Usuario(
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      tipo: tipoUsuario,
    );

    await db.insert(_tabela, usuarioParaInserir.toMap());
  }

  Future<Usuario?> autenticar(String email, String senha) async {
    final db = await _abrirBanco();
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
    final db = await _abrirBanco();
    final resultado = await db.query(_tabela);
    return resultado.map((mapa) => Usuario.fromMap(mapa)).toList();
  }

  Future<void> deletarUsuario(int id) async {
    final db = await _abrirBanco();
    await db.delete(_tabela, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await _abrirBanco();
    await db.update(
      _tabela,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }
}
