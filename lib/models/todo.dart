import 'package:equatable/equatable.dart';

// Model class that holds possible todo properties
// extends the class Equatable.
// Equatable will implement the equality and hashcoding
// read more https://pub.dev/packages/equatable
class Todo extends Equatable {
  final String id;
  final String task;
  final bool isDone;
  final DateTime dateTime;
  final String alarm;
  final String category;

  Todo(
      {this.id,
      this.task,
      this.isDone,
      this.dateTime,
      this.alarm,
      this.category});

  // return a list of properties for this class
  @override
  List<Object> get props => [id, task, isDone, dateTime, alarm, category];

  // helper method to create a new copy of this object
  Todo copyWith({
    String id,
    String task,
    bool isDone,
    DateTime dateTime,
    String alarm,
    String category,
  }) {
    // if value in parameters is null, then return the current value from this object
    return Todo(
        id: id ?? this.id,
        task: task ?? this.task,
        isDone: isDone ?? this.isDone,
        dateTime: dateTime ?? this.dateTime,
        alarm: alarm ?? this.alarm,
        category: category ?? this.category);
  }
}
