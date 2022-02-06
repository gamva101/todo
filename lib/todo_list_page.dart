import 'package:flutter/material.dart';
import 'package:todo/data/todo_bloc.dart';
import 'package:todo/data/todo_dao.dart';
import 'package:todo/data/todo_repository.dart';
import 'package:todo/todo_model.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const String TODO_DATE_FORMAT = 'yyyy-MM-dd HH:mm';
  final TextEditingController _todoTitleController = TextEditingController();
  final TodoDao _todoDao = TodoDao();
  final TodoBloc _todoBloc = TodoBloc(TodoRepository(TodoDao()));
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _createTodoListStreamBuilder(),
      floatingActionButton: _createFloatingButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _createTodoListStreamBuilder() {
    return StreamBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return _createTodoList(snapshot.data!);
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
        stream: _todoBloc.todoListStream);
  }

  Widget _createTodoList(List<TodoModel> todoList) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _createTodoCard(todoList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            thickness: 8.0,
            height: 8.0,
            color: Colors.transparent,
          );
        },
        itemCount: todoList.length);
  }

  Widget _createTodoCard(TodoModel todoModel) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: GestureDetector(
          onLongPress: () {
            setState(() {
              isEdit = !isEdit;
            });
          },
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: _createTodoItemRow(todoModel))),
    );
  }

  Widget _createTodoItemRow(TodoModel todoModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _createTodoItemContentwidget(todoModel),
        GestureDetector(
          onTap: () {
            isEdit ? _deleteTodo(todoModel) : _editTodo();
          },
          child: Icon(isEdit ? Icons.delete : Icons.keyboard_arrow_right,
              color: Colors.blue),
        ),
      ],
    );
  }

  Widget _createTodoItemContentwidget(TodoModel todoModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(todoModel.getTitle(),
            style: TextStyle(fontSize: 24.0, color: Colors.blue)),
        Divider(thickness: 8.0, height: 8.0, color: Colors.transparent),
        Text(DateFormat(TODO_DATE_FORMAT).format(todoModel.getCreatedTime()),
            style: TextStyle(fontSize: 18.0, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _createFloatingButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => _openAddtodoDialog(context),
        child: Icon(Icons.add, color: Colors.white));
  }

  void _openAddtodoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(
              "Input todo",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.blue),
            ),
            content: TextField(controller: _todoTitleController),
            actions: [
              TextButton(
                  onPressed: () {
                    _todoTitleController.text = "";
                    Navigator.pop(context);
                  },
                  child: new Text('Cancel',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue))),
              TextButton(
                  onPressed: () {
                    _addNewTodo(_todoTitleController.text);
                    _todoTitleController.text = "";
                    Navigator.pop(context);
                  },
                  child: new Text('Ok',
                      style: TextStyle(fontSize: 16.0, color: Colors.blue))),
            ],
          );
        });
  }

  void _addNewTodo(String title) async {
    TodoModel todoModel = TodoModel(0, title, DateTime.now(), TodoState.todo);
    _todoBloc.addTodo(todoModel);
  }

  void _deleteTodo(TodoModel todoModel) async {
    _todoBloc.deleteTodo(todoModel);
  }

  _editTodo() {}
}
