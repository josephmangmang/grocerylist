import 'package:equatable/equatable.dart';
import 'package:todolist/models/todo.dart';

abstract class TodoEvent extends Equatable {}

class AddTodo extends TodoEvent {
  final Todo todo;

  AddTodo(this.todo);

  @override
  List<Object> get props => [todo];
}
