import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/repository.dart';
import './todolist.dart';

// A class that handle business logic of our app
// in main screen which is the Todo list screen
class TodolistBloc extends Bloc<TodolistEvent, TodolistState> {
  // create a new instance of Repository class and store this to _repository variable
  final Repository _repository = Repository();

  // variable to hold the stream listener
  StreamSubscription<List<Todo>> _streamSubscription;

  // return the first state for this bloc
  @override
  TodolistState get initialState => LoadingTodoList();

  // flutter will call this when this bloc is no longer in use
  @override
  Future<void> close() {
    // if _streamSubscription is not null cancel any listener. to avoid memory leak
    _streamSubscription?.cancel();
    // add someting
    return super.close();
  }

  // method that called when you call bloc.add(event)
  // put your logic here based on the event sent
  // it return a stream of state
  // meaning you can push any amount of state here then the BlocBuilder.builder() method
  // will be called and decide what widget to display based on the current state
  @override
  Stream<TodolistState> mapEventToState(
    TodolistEvent event,
  ) async* {
    // if we call bloc.add(StartFetchTodoList())
    if (event is StartFetchTodoList) {
      // if _streamSubscription is not null cancel any previous listener;
      _streamSubscription?.cancel();
      // listen for a stream of List<Todo> and assign the listener to a variable called _streamSubscription
      // cancel _streamSubscription when no longer used
      _streamSubscription = _repository.getTodoList().listen((List<Todo> todoList) {
        // when there's changes inside our collection (todolist collection) changes like (new todo adde, updated, deleted).
        //  We will notify the bloc
        // by sending ProcessFirebaseResult event to this the bloc and decide what state will be fire to
        // BlocBuilder
        add(ProcessFirebaseResult(todoList));
      });
    }

    if (event is ProcessFirebaseResult) {
      // if the list is empty we will send empty state
      // then the Widget who implement BLocBuilder.builder() will return a empty widget
      if (event.todoList.isEmpty) {
        yield EmptyTodoList();
      } else {
        // else return the todo list
        yield TodoListLoaded(event.todoList);
      }
    }

    // if user send delete event relay it to repository
    if (event is DeleteTodo) {
      _repository.delete(event.todo);
    }

    // same thing with update
    if (event is UpdateTodo) {
      _repository.update(event.todo);
    }
  }
}
