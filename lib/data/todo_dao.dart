import 'package:todo/data/database.dart';
import 'package:todo/todo_model.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.provder;

  Future<int> createTodo(TodoModel todoModel) async {
    final db = await dbProvider.database;
    final result = db.insert(todoTable, todoModel.toDatabaseJson());
    return result;
  }

  Future<List<TodoModel>> getTodoList() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(todoTable);
    List<TodoModel> todoList = result.isNotEmpty
        ? result.map((item) => TodoModel.fromDatabaseJson(item)).toList()
        : [];
    return todoList;
  }
}
