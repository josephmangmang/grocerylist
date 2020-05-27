import 'package:flutter/material.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[header(), calendar()],
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
                style: TextStyle(fontSize: 18),
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
    return Container(
      height: 100,
      color: Colors.amber,
    );
  }
}
