class TodoModel {
  int? _id;
  String _title;
  String _description;
  late TodoState _state;
  final DateTime _createdTime;
  TodoModel(
      this._id, this._title, this._description, this._createdTime, this._state);

  int? getId() => _id;
  String getTitle() => _title;
  String getDescription() => _description;
  DateTime getCreatedTime() => _createdTime;
  TodoState getTodoState() => _state;

  String setTitle(String title) => _title = title;
  String setDescription(String description) => _description = description;
  TodoState setTodoState(TodoState state) => _state = state;

  factory TodoModel.fromDatabaseJson(Map<String, dynamic> data) => TodoModel(
      data['id'],
      data['title'],
      data['description'],
      DateTime.fromMillisecondsSinceEpoch(data['created_time'] as int),
      getTodoStateByValue(data['state'] as int));

  Map<String, dynamic> toDatabaseJson() => {
        'title': this._title,
        'description': this._description,
        'created_time': this._createdTime.millisecondsSinceEpoch,
        'state': getTodoStateValue(_state)
      };
}

enum TodoState { todo, inProgress, done }

int getTodoStateValue(TodoState state) {
  switch (state) {
    case TodoState.todo:
      return 0;
    case TodoState.inProgress:
      return 1;
    case TodoState.done:
      return 2;
    default:
      return 0;
  }
}

TodoState getTodoStateByValue(int stateValue) {
  switch (stateValue) {
    case 0:
      return TodoState.todo;
    case 1:
      return TodoState.inProgress;
    case 2:
      return TodoState.done;
    default:
      return TodoState.todo;
  }
}
