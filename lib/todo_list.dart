import 'package:flutter/material.dart';
import 'package:todo/todo_list_page.dart';

class TodoListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  final List<TabItem> _tabItems = [
    TabItem("Todo", Icons.clear),
    TabItem("In Progress", Icons.loop),
    TabItem("Done", Icons.check)
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
        body: TodoListPage(),
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

  TabItem(String title, IconData icon) {
    _title = title;
    _icon = icon;
  }

  String getTitle() => _title;
  IconData getIcon() => _icon;
}
