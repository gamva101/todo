import 'package:flutter/material.dart';
import 'package:todo/model/todo_state.dart';
import 'package:todo/todo_list_page.dart';

class TodoListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final List<TabItem> _tabItems = [
    TabItem("Todo", Icons.clear, TodoState.todo),
    TabItem("In Progress", Icons.loop, TodoState.inProgress),
    TabItem("Done", Icons.check, TodoState.done)
  ];

  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter todo list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_tabItems[_currentTabIndex].getTitle()),
        ),
        body: TodoListPage(_tabItems[_currentTabIndex].getState()),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      items: _tabItems
          .map((tabItem) => BottomNavigationBarItem(
              icon: Icon(tabItem.getIcon()), label: tabItem.getTitle()))
          .toList(),
      currentIndex: _currentTabIndex,
      onTap: (int index) => {
        setState(() {
          _currentTabIndex = index;
        })
      },
    );
  }
}

class TabItem {
  late String _title;
  late IconData _icon;
  late TodoState _state;

  TabItem(String title, IconData icon, TodoState state) {
    _title = title;
    _icon = icon;
    _state = state;
  }

  String getTitle() => _title;
  IconData getIcon() => _icon;
  TodoState getState() => _state;
}
