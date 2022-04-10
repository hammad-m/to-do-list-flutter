import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class Task {
  late dynamic id;
  String title;
  String text;
  String description;
  bool status = false;
  DateTime dueDate;
  late DateTime completedOn;

  Task({
    required this.title,
    required this.text,
    required this.description,
    required this.dueDate,
  });
}

class TaskList with ChangeNotifier {
  List<Task> _tasks = [];

  dynamic toJSON({required Task task}) => {
        'title': task.title,
        'text': task.text,
        'description': task.description,
        'status': task.status,
        'dueDate': task.dueDate,
      };

  Future<void> _uploadTaskToFirebase(Task task) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc()
        .set(toJSON(task: task));
  }

  addTask({required Task task}) async {
    _tasks.add(task);
    await _uploadTaskToFirebase(task);
    notifyListeners();
  }

  Future<void> _getTasksFromFirebase() async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _tasks.clear();
      for (var doc in querySnapshot.docs) {
        _tasks.add(
          Task(
            title: doc["title"],
            text: doc["text"],
            description: doc["description"],
            dueDate: (doc["dueDate"] as Timestamp).toDate(),
          ),
        );
        if (doc.get("status")) {
          _tasks[_tasks.length - 1].status = true;
          _tasks[_tasks.length - 1].completedOn =
              (doc["completedOn"] as Timestamp).toDate();
        }
        _tasks[_tasks.length - 1].id = doc.reference.id;
      }
    });
    sortList();
    sortListByStatus();
  }

  void refreshList() async {
    await _getTasksFromFirebase();
    notifyListeners();
  }

  List<Task> getList() {
    return _tasks;
  }

  int getListLength() {
    return _tasks.length;
  }

  bool isEmpty() {
    return _tasks.isEmpty;
  }

  String getTitle(int index) {
    return _tasks[index].title;
  }

  String getSampleText(int index) {
    return _tasks[index].text;
  }

  String getDescription(int index) {
    return _tasks[index].description;
  }

  bool getStatus(int index) {
    return _tasks[index].status;
  }

  DateTime getDueDate(int index) {
    return _tasks[index].dueDate;
  }

  DateTime getCompletionDate(int index) {
    return _tasks[index].completedOn;
  }

  Future<void> setCompletedOnFirebase(int index) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(_tasks[index].id)
        .update({'completedOn': DateTime.now()});
  }

  void setCompletedOn(int index) async {
    _tasks[index].completedOn = DateTime.now();
    await setCompletedOnFirebase(index);
    notifyListeners();
  }

  Future<void> setStatusFirebase(int index) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(_tasks[index].id)
        .update({'status': true});
  }

  void setStatus(int index) async {
    _tasks[index].status = true;
    await setStatusFirebase(index);
    notifyListeners();
  }

  bool toggleStatus(int index) {
    _tasks[index].status = !_tasks[index].status;
    notifyListeners();
    return _tasks[index].status;
  }

  Future<void> deleteTaskFirebase(int index) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(_tasks[index].id)
        .delete();
  }

  void deleteTask(int index) async {
    await deleteTaskFirebase(index);
    _tasks.removeAt(index);
    //refreshList();
    notifyListeners();
  }

  void sortList() {
    _tasks.sort((a, b) => a.dueDate.isBefore(b.dueDate) ? -1 : 1);
    notifyListeners();
  }

  void sortListByStatus() {
    _tasks.sort((a, b) => !a.status ? -1 : 1);
    notifyListeners();
  }

  Future<void> _updateFieldsInFirebase(
      {required Task task, required dynamic id}) async {
    await FirebaseFirestore.instance
        .collection('Tasks')
        .doc(id)
        .set(toJSON(task: task));
  }

  void updateTask(
      {required dynamic id,
      required String title,
      required String description,
      required String text,
      required DateTime dueDate,
      required bool status}) async {
    int index = _tasks.indexWhere((element) => element.id == id);
    _tasks[index].title = title;
    _tasks[index].description = description;
    _tasks[index].text = text;
    _tasks[index].dueDate = dueDate;
    _tasks[index].status = status;
    if (status == true) {
      _tasks[index].completedOn = DateTime.now();
    }

    await _updateFieldsInFirebase(task: _tasks[index], id: id);
  }
}
