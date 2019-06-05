import 'dart:async';
import 'dart:io';
import "package:todo/modal/todo_item.dart";
import 'package:path/path.dart';
import "package:path_provider/path_provider.dart";
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _helper = new DatabaseHelper.internal();
  factory DatabaseHelper() => _helper;

  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, "todoitems.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE todo(id INTEGER PRIMARY KEY, name TEXT,dateCreated TEXT,done INTEGER)");
  }

  Future<int> saveTodo(TodoItem todo) async {
    var dbClient = await db;
    int res = await dbClient.insert("todo", todo.toMap());
    return res;
  }

  Future<List> getTodos() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM todo");
    return res.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM todo"));
  }

  Future<TodoItem> getTodo(int id) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM todo WHERE id =$id");
    if (res.length == 0) return null;
    return new TodoItem.fromMap(res.first);
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    return await dbClient.delete("todo", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateTodo(TodoItem todo) async {
    var dbClient = await db;
    return dbClient
        .update("todo", todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<int> doneTodo(int id,int done) async {
    var dbClient = await db;
    return dbClient.rawUpdate("Update todo SET done = $done WHERE id = $id");
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
