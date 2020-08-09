import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist/models/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(InitialState());

  void loadTodoList() {
    List<Todo> todoList = [
      Todo(task: "Drink water", isDone: false, dateTime: DateTime.now()),
      Todo(task: "Eat banana", isDone: false, dateTime: DateTime.now()),
    ];
    emit(TodoLoaded(todoList));

  }
}
