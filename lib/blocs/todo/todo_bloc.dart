import 'package:bloc/bloc.dart';
import 'package:todolist/blocs/todo/todo.dart';
import 'package:todolist/repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final Repository repository = Repository();

  @override
  TodoState get initialState => InitialState();

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is AddTodo) {
      // add todo to database
      repository.add(event.todo);
    }
  }
}
