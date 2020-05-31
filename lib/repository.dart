import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist/models/todo.dart';

// Class that handle the data manipulation of out app
// this class don't know any widget things
// all logic inside this class is about data
class Repository {
  void add(Todo todo) {
    // to add new document to our todolist collection
    // pass the todo object by converting it to a Map type. Map is a key value pair.
    // left side is the key and right side is the value.
    Firestore.instance.collection('todolist').add({
      'task': todo.task,
      'isDone': todo.isDone,
      'dateTime': todo.dateTime,
      'alarm': todo.alarm,
      'category': todo.category
    });
  }

  void delete(Todo todo) {
    // to delete a document
    // get the firestore instance and get todolist collection,
    // get the reference to the document by passing the todo id
    Firestore.instance.collection('todolist').document(todo.id).delete();
  }

  void update(Todo todo) {
    // get the firestore instance and get todolist collection,
    // get the reference to the document by passing the todo id
    Firestore.instance.collection('todolist').document(todo.id).updateData({
      'task': todo.task,
      'isDone': todo.isDone,
      'dateTime': todo.dateTime,
      'alarm': todo.alarm,
      'category': todo.category
    });
  }

  //  return a stream of todo list

  //  Streams provide an asynchronous sequence of data.
  //  Data sequences include user-generated events and data read from files.
  //  You can process a stream using either await for or listen() from the Stream API.
  //  Streams provide a way to respond to errors.
  //  There are two kinds of streams: single subscription or broadcast.
  // more about Stream https://dart.dev/tutorials/language/streams
  //
  Stream<List<Todo>> getTodoList() {
    return Firestore.instance
        // we locate our todo list collection reference
        .collection('todolist')
        // then get the current snapshots (latest todo list item)
        .snapshots()
        // listen every change in our firebase database inside todolist collection
        // map(convert) the snapshots to a List of Todo
        .map((QuerySnapshot snapshots) {
      // get the documents and convert this to a List<Todo>
      return snapshots.documents.map((DocumentSnapshot document) {
        // to get the data inside document
        // call document.data and this will return a Map of String key and dynamic value.
        // dynamic means any type. In java this is Object
        Map<String, dynamic> todoMap = document.data;
        return Todo(
          // get the document id and store it in Todo variable id
          id: document.documentID,
          task: todoMap['task'],
          isDone: todoMap['isDone'],
          // convert firebase Timestamp to DateTime object because our Todo.dateTime parameter only accept DateTime type
          dateTime: todoMap['dateTime'] != null
              ? (todoMap['dateTime'] as Timestamp).toDate()
              : null,
          alarm: todoMap['alarm'],
          category: todoMap['category'],
        );
        // convert this iterable to a list
      }).toList();
    });
  }
}
