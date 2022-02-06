import 'package:todo/data/todo_dao.dart';
import 'package:todo/todo_model.dart';

class TodoRepository {
  final TodoDao _todoDao;

  TodoRepository(this._todoDao);

  Future<List<TodoModel>> getTodoList() => _todoDao.getTodoList();
  Future<int> createTodo(TodoModel todo) => _todoDao.createTodo(todo);
}