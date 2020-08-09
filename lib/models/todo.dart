class Todo {
  final String id;
  final String task;
  final bool isDone;
  final DateTime dateTime;
  final String alarm;
  final String category;

  Todo(
      {this.id,
      this.task,
      this.isDone = false,
      this.dateTime,
      this.alarm,
      this.category});
}
