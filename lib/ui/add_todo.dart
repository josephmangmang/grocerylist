import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/todo.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController taskController = TextEditingController();
  var categoryTextController = TextEditingController();

  DateTime dateTime;

  String alarmText = '15 min before';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    closeButton(),
                    inputArea(),
                    SizedBox(
                      height: 64,
                    ),
                    time(),
                    alarm(),
                    category(),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: addButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget closeButton() {
    return GestureDetector(
      onTap: () {
        // close the page
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          Icons.close,
          size: 32,
        ),
      ),
    );
  }

  inputArea() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: TextField(
        controller: taskController,
        decoration: InputDecoration(
            hintText: "Write task here",
            hintStyle: TextStyle(color: Colors.black26)),
        style: TextStyle(fontSize: 38),
      ),
    );
  }

  alarm() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Icon(Icons.notifications_active),
          SizedBox(
            width: 24,
          ),
          DropdownButton(
              value: alarmText,
              items: [
                DropdownMenuItem(
                  value: '15 min before',
                  child: Text('15 min before'),
                ),
                DropdownMenuItem(
                  value: '1 hour before',
                  child: Text('1 hour before'),
                )
              ],
              onChanged: (value) {
                setState(() {
                  alarmText = value;
                });
              })
        ],
      ),
    );
  }

  category() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Icon(Icons.category),
          SizedBox(
            width: 24,
          ),
          Expanded(
            child: TextField(
              controller: categoryTextController,
              decoration: InputDecoration.collapsed(hintText: 'Category'),
            ),
          )
        ],
      ),
    );
  }

  addButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: MaterialButton(
          minWidth: double.infinity,
          color: Colors.blue,
          onPressed: () {
            // TODO handle add

            // close page after adding
            Navigator.pop(context);
          },
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  time() {
    return GestureDetector(
      onTap: () async {
        // open time picker
        DateTime selectedDate = await showDatePicker(
          initialDate: DateTime.now(),
          lastDate: DateTime(
            2030,
          ),
          firstDate: DateTime(
            2000,
          ),
          context: context,
        );
        final timeOfDay = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        setState(() {
          if (selectedDate != null || timeOfDay != null) {
            dateTime = DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, timeOfDay.hour, timeOfDay.minute);
          }
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24.0, right: 24, top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Icon(Icons.alarm),
            SizedBox(
              width: 24,
            ),
            Text(dateTime == null
                ? 'Select Time'
                : TimeOfDay.fromDateTime(dateTime).format(context))
          ],
        ),
      ),
    );
  }
}
