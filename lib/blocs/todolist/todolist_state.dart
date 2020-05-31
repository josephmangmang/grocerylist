import 'package:equatable/equatable.dart';
import 'package:todolist/models/todo.dart';

abstract class TodolistState extends Equatable {
  const TodolistState();
}

class LoadingTodoList extends TodolistState {
  @override
  List<Object> get props => null;
}

class EmptyTodoList extends TodolistState {
  @override
  List<Object> get props => null;
}

class TodoListLoaded extends TodolistState {
  final List<Todo> todoList;

  TodoListLoaded(this.todoList);

  @override
  List<Object> get props => [todoList];
}
