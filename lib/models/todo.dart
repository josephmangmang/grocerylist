import 'package:equatable/equatable.dart';

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

  @override
  List<Object> get props => [id, task, isDone, dateTime, alarm, category];

  Todo copyWith({
    String id,
    String task,
    bool isDone,
    DateTime dateTime,
    String alarm,
    String category,
  }) {
    return Todo(
        id: id ?? this.id,
        task: task ?? this.task,
        isDone: isDone ?? this.isDone,
        dateTime: dateTime ?? this.dateTime,
        alarm: alarm ?? this.alarm,
        category: category ?? this.category);
  }
}
