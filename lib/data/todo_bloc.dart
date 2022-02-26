import 'dart:async';
import 'dart:developer';

import 'package:todo/data/todo_repository.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/model/todo_state.dart';

class TodoBloc {
  TodoState? _state;
  final TodoRepository _todoRepository;
  final StreamController<List<TodoModel>> _todoController =
      StreamController<List<TodoModel>>.broadcast();

  get todoListStream => _todoController.stream;

  TodoBloc(this._todoRepository, [this._state = TodoState.all]) {
    getTodoList();
  }

  void getTodoList() async {
    if (_state == null) {
      List<TodoModel> todoList = await _todoRepository.getTodoList();
      _todoController.sink.add(todoList);
    } else {
      log('state ' + _state.toString());
      List<TodoModel> todoList =
          await _todoRepository.getTodoListByState(_state!);
      _todoController.sink.add(todoList);
    }
  }

  void addTodo(TodoModel todo) async {
    await _todoRepository.createTodo(todo);
    getTodoList();
  }

  void updateTodo(TodoModel todo) async {
    await _todoRepository.updateTodo(todo);
    getTodoList();
  }

  void deleteTodo(TodoModel todo) async {
    await _todoRepository.deleteTodo(todo);
    getTodoList();
  }
}
