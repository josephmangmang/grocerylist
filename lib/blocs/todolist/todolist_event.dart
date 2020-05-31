import 'package:equatable/equatable.dart';
import 'package:todolist/models/todo.dart';

abstract class TodolistEvent extends Equatable {
  const TodolistEvent();
}

class StartFetchTodoList extends TodolistEvent {
  @override
  List<Object> get props => null;
}

class ProcessFirebaseResult extends TodolistEvent {
  final List<Todo> todoList;

  ProcessFirebaseResult(this.todoList);

  @override
  List<Object> get props => [todoList];
}

class DeleteTodo extends TodolistEvent {
  final Todo todo;

  DeleteTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodolistEvent {
  final Todo todo;

  UpdateTodo(this.todo);

  @override
  List<Object> get props => [todo];
}
