import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo/data/todo_bloc.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/model/todo_state.dart';

class AddPage extends StatefulWidget {
  TodoBloc _todoBloc;
  TodoModel _todoModel;

  AddPage(this._todoBloc, this._todoModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _todoTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String title =
        widget._todoModel.getId() != null ? 'Update todo' : 'Add todo';
    return Scaffold(
        appBar: AppBar(title: Text(title)), body: _createTitleForm());
  }

  Widget _createTitleForm() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TodoModel? _todoModel = widget._todoModel;
    bool _isEdit = _todoModel.getId() != null;
    TodoState _state = _todoModel.getTodoState();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter todo title',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onChanged: (value) {
              _todoModel.setTitle(value);
            },
            initialValue: _todoModel.getTitle(),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          TextFormField(
            decoration: const InputDecoration(
                hintText: 'Enter description',
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            maxLines: 20,
            minLines: 5,
            onChanged: (value) {
              _todoModel.setDescription(value);
            },
            initialValue: _todoModel.getDescription(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  Radio(
                      value: TodoState.todo,
                      groupValue: _state,
                      onChanged: (TodoState? value) {
                        setState(() {
                          _state = value!;
                          _todoModel.setTodoState(_state);
                        });
                      }),
                  Text('To do')
                ]),
                Column(children: [
                  Radio(
                      value: TodoState.inProgress,
                      groupValue: _state,
                      onChanged: (TodoState? value) {
                        log('set state ' + value.toString());
                        setState(() {
                          _state = value!;
                          _todoModel.setTodoState(_state);
                        });
                      }),
                  Text('In progress')
                ]),
                Column(children: [
                  Radio(
                      value: TodoState.done,
                      groupValue: _state,
                      onChanged: (TodoState? value) {
                        log('set state ' + value.toString());
                        setState(() {
                          _state = value!;
                          _todoModel.setTodoState(_state);
                        });
                      }),
                  Text('Done')
                ]),
              ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  log('isEdit ' + _isEdit.toString());
                  if (_isEdit) {
                    _updateTodo(_todoModel);
                  } else {
                    _addNewTodo(_todoModel);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewTodo(TodoModel todo) async {
    widget._todoBloc.addTodo(todo);
  }

  void _updateTodo(TodoModel todo) async {
    widget._todoBloc.updateTodo(todo);
  }
}
