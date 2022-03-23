import 'package:flutter/cupertino.dart';

class Task {
  final String title;
  final String text;
  final String description;
  bool status = false;
  final DateTime dueDate;
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

  changeStatus({required Task task}) {
    task.status = true;
    notifyListeners();
  }

  addTask({required Task task}) {
    _tasks.add(task);
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

  String getTitle(index) {
    return _tasks[index].title;
  }

  String getSampleText(index) {
    return _tasks[index].text;
  }

  String getDescription(index) {
    return _tasks[index].description;
  }

  bool getStatus(index) {
    return _tasks[index].status;
  }

  DateTime getDueDate(index) {
    return _tasks[index].dueDate;
  }

  DateTime getCompletionDate(index) {
    return _tasks[index].completedOn;
  }

  void setCompletedOn(index) {
    _tasks[index].completedOn = DateTime.now();
    notifyListeners();
  }

  void setStatus(index) {
    _tasks[index].status = true;
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
}
