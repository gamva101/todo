import 'dart:developer';

import 'package:todo/data/database.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/model/todo_state.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.provder;

  Future<int> createTodo(TodoModel todoModel) async {
    final db = await dbProvider.database;
    final result = db.insert(todoTable, todoModel.toDatabaseJson());
    return result;
  }

  Future<int> updateTodo(TodoModel todoModel) async {
    final db = await dbProvider.database;
    final result = db.update(todoTable, todoModel.toDatabaseJson(),
        where: 'id=?', whereArgs: [todoModel.getId()]);
    return result;
  }

  Future<List<TodoModel>> getTodoList() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result =
        await db.query(todoTable, orderBy: 'created_time DESC');
    List<TodoModel> todoList = result.isNotEmpty
        ? result.map((item) => TodoModel.fromDatabaseJson(item)).toList()
        : [];
    return todoList;
  }

  Future<List<TodoModel>> getTodoListByState(TodoState state) async {
    final db = await dbProvider.database;
    // List<Map<String, dynamic>> result =
    //     await db.query(todoTable, orderBy: 'created_time DESC');
    log('whereArgs ' + state.toString());
    int stateValue = getTodoStateValue(state);
    List<Map<String, dynamic>> result = await db.query(todoTable,
        orderBy: 'created_time DESC',
        where: 'state = ?',
        whereArgs: [stateValue]);
    List<TodoModel> todoList = result.isNotEmpty
        ? result.map((item) => TodoModel.fromDatabaseJson(item)).toList()
        : [];
    return todoList;
  }

  Future<int> deleteTodo(TodoModel todo) async {
    final db = await dbProvider.database;
    final result =
        db.delete(todoTable, where: 'id = ?', whereArgs: [todo.getId()]);
    return result;
  }
}
