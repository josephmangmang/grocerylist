part of 'todo_cubit.dart';

abstract class TodoState extends Equatable {}

class InitialState extends TodoState {
  @override
  List<Object> get props => [];
}

class LoadingState extends TodoState {
  @override
  List<Object> get props => [];
}

class ErrorState extends TodoState {
  final String message;

  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class TodoLoaded extends TodoState{
  final List<Todo> todoList;

  TodoLoaded(this.todoList);

  @override
  List<Object> get props => [todoList];
}