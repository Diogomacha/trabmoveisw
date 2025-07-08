import 'package:sqflite/sqflite.dart';
import '../core/app_database.dart';
import '../models/produtos.dart';

class CamisaDao {
  Future<Database> _getDatabase() async {
    return await AppDatabase.instance.database;
  }

  Future<int> inserirCamisa(Camisa camisa) async {
    final db = await _getDatabase();
    return await db.insert(
      'camisas',
      camisa.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Camisa>> listarCamisas() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('camisas');

    return List.generate(maps.length, (i) {
      return Camisa.fromMap(maps[i]);
    });
  }

  Future<int> atualizarCamisa(Camisa camisa) async {
    final db = await _getDatabase();
    return await db.update(
      'camisas',
      camisa.toMap(),
      where: 'id = ?',
      whereArgs: [camisa.id],
    );
  }

  Future<int> deletarCamisa(int id) async {
    final db = await _getDatabase();
    return await db.delete(
      'camisas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
