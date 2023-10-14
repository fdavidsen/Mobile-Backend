import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  Database? _database;
  final String _table_todo = 'todo';
  final String _db_name = 'apple_todo.db';
  final int _db_version = 1;

  DBManager() {
    _openDB();
  }

  get db => _database;

  Future<void> _openDB() async {
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
  }

  Future<int> insertTodo(data) async {
    return await _database!.insert(
      _table_todo,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, String>>> getAllTodo() async {
    if (_database != null) {
      List<Map<String, dynamic>> result = await _database!.query(_table_todo);

      return List.generate(
          result.length,
          (index) => {
                'id': result[index]['id'].toString(),
                'title': result[index]['title'] as String,
                'keterangan': result[index]['keterangan'] as String,
                'mulai': result[index]['mulai'] as String,
                'selesai': result[index]['selesai'] as String,
                'isDisplayed': result[index]['isDisplayed'] as String,
                'isDone': result[index]['isDone'] as String,
                'kategori': result[index]['kategori'] as String,
                'color': result[index]['color'] as String
              });
    }
    return [];
  }

  Future<void> updateTodo(String id, Map<String, String> dataMap) async {
    await _database?.update(
      _table_todo,
      dataMap,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setTaskAsDone(String id) async {
    await _database?.update(
      _table_todo,
      {'isDone': 'true'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTodo(String id) async {
    await _database?.delete(
      _table_todo,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTodo() async {
    await _database?.delete(_table_todo);
  }
}
