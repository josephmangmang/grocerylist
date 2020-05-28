import 'dart:ui';

import 'package:flutter/material.dart';

class Todo {
  Color color;
  String task;
  bool isDone;
  DateTime dateTime;
  String alarm;
  String category;

  Todo({this.color, this.task, this.isDone, this.dateTime, this.alarm,
      this.category});
}
