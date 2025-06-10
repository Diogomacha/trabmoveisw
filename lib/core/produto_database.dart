import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProdutoDatabase {
  static final ProdutoDatabase _instance = ProdutoDatabase._internal();
  static Database? _database;

  ProdutoDatabase._internal();


  static ProdutoDatabase get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'produto_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE camisas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
             nome TEXT NOT NULL,
             descricao TEXT,
             preco REAL,
             imagem TEXT
                  )
          ''');
      },
    );
  }
}
