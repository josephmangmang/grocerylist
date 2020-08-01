import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todolist/add_todo.dart';
import 'package:todolist/blocs/todolist/todolist.dart';
import 'package:todolist/models/todo.dart';

/// The starting point of the app.
void main() {
  runApp(HomePage());
}

// our main page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // create a new instance of class TodolistBloc and store it in a variable called
  // todolistBloc so that later on we can access it anywhere inside _HomePageState
  final TodolistBloc todolistBloc = TodolistBloc();

  // when a widget launched, this is the first method that will be called
  // this is the place where you can prepare something  or initialize something before
  // widget call the build() method
  @override
  void initState() {
    // call add(Event) method from your bloc so that you can add a new event
    // this will notify your TodolistBloc class that a new Event is being fire.
    // in TodolistBloc, mapEventToState will be called and you can check what kind of
    // event is being sent
    todolistBloc.add(StartFetchTodoList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // new changes here
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

  // prepare the widget that represent your header
  Widget header() {
    // the current time
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
                // format the current time to a readable string and display to screen
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

  // return a widget that represent the calendar part of the ui
  Widget calendar() {
    // current time
    // DateTime now = DateTime.now();
    // and
    // var now = DateTime.now();
    // are same
    var now = DateTime.now();
    // to get this week sunday DateTime. We subtract the current day by daysPerWeek - current weekday
    var sunday =
        now.subtract(Duration(days: DateTime.daysPerWeek - now.weekday));
    // create a new list that can store DateTime object initialize it with empty list []
    List<DateTime> weekDays = [];
    // iterate from 0 to daysPerWeek(7)
    for (int i = 0; i < DateTime.daysPerWeek; i++) {
      // get the next day by adding 1 day and store it to our list weekDays
      weekDays.add(sunday.add(Duration(days: i)));
    }
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // prepare the children widget
        // map (convert) every item inside weekDays list to a widget
        children: weekDays.map((DateTime date) {
          // call days() method to prepare a widget for every DateTime
          //
          return days(
              weekday: '${getWeekDayString(date.weekday)}', day: '${date.day}');
          // map() method return Iterable type but our children parameter expect a List of Widget not Iterable of Widget
          // convert it by calling toList()
        }).toList(),
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

  // method that prepare the date item in calendar widget
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

  // method that prepare the list widget in the ui
  Widget todoList() {
    // to receive a stream of state from todolistBloc we need to wrap our widget
    // with BLocBuilder. When new state is fire, the builder(context, state) method
    // will be called and we decide what widget to display based on this state
    return BlocBuilder(
        // the bloc that we will listening for any state change
        bloc: todolistBloc,
        builder: (context, TodolistState state) {
          // when the bloc fires a LoadingTodoList state we will show a loading screen
          if (state is LoadingTodoList) {
            return Center(child: CircularProgressIndicator());
          }
          // for empty state we will display center text
          if (state is EmptyTodoList) {
            return Center(
              child: Text("No Task yet. Click + to add."),
            );
          }
          // if the above condition is not meet. Show the list of todo to the screen
          if (state is TodoListLoaded) {
            return ListView(
              shrinkWrap: true,
              // convert the todo list to a list of Widget that represent every todo item
              children: state.todoList.map((Todo todo) {
                // create a new instance(copy) of TodoItem widget for every Todo object
                return TodoItem(
                  todo,
                  // pass a key so that flutter can identify each of our widget.
                  // later on when we change something in our TodoItem state like checkbox
                  // flutter can identify which widget should be rebuild
                  key: ValueKey(todo),
                  // pass the todolistbloc so that we can access it inside TodoItem class when changing checkbox state
                  // and deleting item
                  todolistBloc: todolistBloc,
                );
              }).toList(),
            );
          }
          return Container();
        });
  }
}

class TodoItem extends StatelessWidget {
  // store the Todo object for this TodoItem widget
  final Todo todo;
  final TodolistBloc todolistBloc;

  TodoItem(this.todo, {Key key, @required this.todolistBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // to implement swipe left/right to delete, wrap out widget item with Dismissible widget
    return Dismissible(
      // pass a unique value to identify the current widget
      key: ValueKey(todo.id),
      background: Container(
        color: Colors.red,
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      // onDismissed parameter accept a method that will be called when user swipe the item
      // left/right
      onDismissed: (direction) {
        // when user swipe send Delete event to our todolistBloc and pass the todo that we will delete
        todolistBloc.add(DeleteTodo(todo));
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
                // when checkbox is clicked. send event to todolistBloc
                // passing a new copy of object Todo with the new isDone value
                todolistBloc.add(UpdateTodo(todo.copyWith(isDone: isDone)));
              },
            )
          ],
        ),
      ),
    );
  }

// generate a random color
  Color randomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }
}
