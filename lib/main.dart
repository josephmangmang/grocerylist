import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todolist/add_todo.dart';
import 'package:todolist/blocs/todolist/todolist.dart';
import 'package:todolist/models/todo.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodolistBloc todolistBloc = TodolistBloc();

  @override
  void initState() {
    todolistBloc.add(StartFetchTodoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    header(),
                    SizedBox(
                      height: 50,
                    ),
                    calendar(),
                    Expanded(child: todoList()),
                  ],
                ),
                Builder(
                  builder: (BuildContext context) {
                    return Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          // navigate to next page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      // the next page widget
                                      AddTodoPage()));
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    final now = DateTime.now();
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                // format to ex:     "Friday, May 11"
                DateFormat("EEEE, MMM dd").format(now),
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

  Widget calendar() {
    var now = DateTime.now();
    var sunday = now.subtract(Duration(days: 8 - now.weekday));
    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(sunday.add(Duration(days: i)));
    }
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

  Widget todoList() {
    return BlocBuilder(
        bloc: todolistBloc,
        builder: (context, TodolistState state) {
          if (state is LoadingTodoList) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is EmptyTodoList) {
            return Center(
              child: Text("No Task yet. Click + to add."),
            );
          }
          if (state is TodoListLoaded) {
            return ListView(
              shrinkWrap: true,
              children: state.todoList.map((Todo todo) {
                return TodoItem(
                  todo,
                  key: ValueKey(todo),
                  todolistBloc: todolistBloc,
                  onDeleteConfirmed: (Todo todo) {
                    todolistBloc.add(DeleteTodo(todo));
                  },
                );
              }).toList(),
            );
          }
          return Container();
        });
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo todo) onDeleteConfirmed;
  final TodolistBloc todolistBloc;

  TodoItem(this.todo, {Key key, this.onDeleteConfirmed, this.todolistBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: Container(
        color: Colors.red,
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (onDeleteConfirmed != null) {
          onDeleteConfirmed(todo);
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              height: 10,
              width: 10,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: randomColor()),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 24, right: 16),
                  child: Text(todo.task)),
            ),
            Checkbox(
              value: todo.isDone,
              onChanged: (isDone) {
                todolistBloc.add(UpdateTodo(todo.copyWith(isDone: isDone)));
              },
            )
          ],
        ),
      ),
    );
  }

  Color randomColor() {
    var randomInt = Random.secure().nextInt(5);
    switch (randomInt) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;
      case 3:
        return Colors.green;
      case 4:
        return Colors.amber;
      case 5:
        return Colors.pink;
    }
    return Colors.cyan;
  }
}
