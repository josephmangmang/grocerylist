import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                header(),
                SizedBox(
                  height: 50,
                ),
                calendar(),
                todoList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Friday, May 11",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "To-Do List",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Spacer(),
          Icon(Icons.search)
        ],
      ),
    );
  }

  // prepare a widget that represent the calendar view
  Widget calendar() {
    var now = DateTime.now();
    var sunday = now.subtract(Duration(days: 8 - now.weekday));
    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(sunday.add(Duration(days: i)));
    }
    print(weekDays);
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDays
            .map((DateTime e) => days(
                weekday: '${getWeekDayString(e.weekday)}', day: '${e.day}'))
            .toList(),
      ),
    );
  }

  ///
  /// Convert int weekday to String weekday
  ///
  String getWeekDayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      case 7:
        return 'S';
    }
    return '';
  }

  // return a widget for calendar item
  Widget days({String weekday, String day}) {
    return Column(
      children: <Widget>[
        Text(
          weekday,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          day,
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  // widget for scrollable todo list
  Widget todoList() {
    List<Todo> todoList = [];

    todoList.add(Todo(
        color: Colors.lightBlue,
        task: "Set up office",
        isDone: true,
        dateTime: DateTime.now(),
        alarm: "15 mins before",
        category: 'Work'));

    todoList.add(Todo(
        color: Colors.lightBlue,
        task: "Daily UI #43",
        isDone: false,
        dateTime: DateTime.now(),
        alarm: "15 mins before",
        category: 'Work'));

    return ListView(
      shrinkWrap: true,
      children: todoList.map((Todo todo) {
        return TodoItem(todo);
      }).toList(),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;

  TodoItem(this.todo);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            height: 10,
            width: 10,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: todo.color),
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 24, right: 16),
                child: Text(todo.task)),
          ),
          Checkbox(
            value: todo.isDone,
            onChanged: (isDone) {},
          )
        ],
      ),
    );
  }
}
