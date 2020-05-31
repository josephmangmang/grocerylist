import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/repository.dart';
import './todolist.dart';

class TodolistBloc extends Bloc<TodolistEvent, TodolistState> {
  final Repository _repository = Repository();

  StreamSubscription<List<Todo>> _streamSubscription;

  @override
  TodolistState get initialState => LoadingTodoList();

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<TodolistState> mapEventToState(
    TodolistEvent event,
  ) async* {
    if (event is StartFetchTodoList) {
      _streamSubscription?.cancel();
      _streamSubscription = _repository.getTodoList().listen((todoList) {
        add(ProcessFirebaseResult(todoList));
      });
    }

    if (event is ProcessFirebaseResult) {
      if (event.todoList.isEmpty) {
        yield EmptyTodoList();
      } else {
        yield TodoListLoaded(event.todoList);
      }
    }

    if (event is DeleteTodo) {
      _repository.delete(event.todo);
    }

    if (event is UpdateTodo) {
      _repository.update(event.todo);
    }
  }
}
