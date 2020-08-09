import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/models/todo.dart';

class Repository {
  void add(Todo todo) {
    Firestore.instance.collection('todolist').add({
      'task': todo.task,
      'isDone': todo.isDone,
      'dateTime': todo.dateTime,
      'alarm': todo.alarm,
      'category': todo.category
    });
  }

  void delete(Todo todo) {
    Firestore.instance..collection('todolist').document(todo.id).delete();
  }

  void update(Todo todo) {
    Firestore.instance.collection('todolist').document(todo.id).setData({
      'task': todo.task,
      'isDone': todo.isDone,
      'dateTime': todo.dateTime,
      'alarm': todo.alarm,
      'category': todo.category
    }, merge: true);
  }

  Stream<List<Todo>> getTodoList() {
    return Firestore.instance
        .collection('todolist')
        .snapshots()
        .map((QuerySnapshot snapshots) {
      return snapshots.documents.map((DocumentSnapshot document) {
        Map<String, dynamic> todoMap = document.data;
        return Todo(
          id: document.documentID,
          task: todoMap['task'],
          isDone: todoMap['isDone'],
          dateTime: todoMap['dateTime'] != null
              ? (todoMap['dateTime'] as Timestamp).toDate()
              : null,
          alarm: todoMap['alarm'],
          category: todoMap['category'],
        );
      }).toList();
    });
  }
}
