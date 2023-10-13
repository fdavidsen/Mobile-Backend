import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  Database? _database;
  final String _table_todo = 'todo';
  final String _db_name = 'apple_todo.db';
  final int _db_version = 1;

  DBManager() {
    openDB();
  }

  Future<void> openDB() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table_todo
            (id INTEGER PRIMARY KEY,
            title TEXT,
            keterangan TEXT,
            mulai TEXT,
            selesai TEXT,
            isDisplayed TEXT,
            isDone TEXT,
            kategori TEXT,
            color TEXT)
        ''');
      },
      version: _db_version,
    );
    print('db done');
  }

  Future<void> insertTodo(data) async {
    print(data);
    await _database!.insert(
      _table_todo,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List> getAllTodo() async {
    print(_database);
    if (_database != null) {
      return await _database!.query(_table_todo);
    }
    return [];
  }
}
