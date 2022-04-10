import 'package:assignment_4/tasks.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import "dart:async";
import 'package:provider/provider.dart';

class NewTask extends StatefulWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Task',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TaskList>().refreshList();
            context.read<TaskList>().sortList();
            context.read<TaskList>().sortListByStatus();
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController textController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String _selectedDate = 'Tap to select date';
  Future _selectDate(BuildContext context) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(
        () {
          _selectedDate = DateFormat("yyyy-MM-dd").format(d);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    dateController.text = _selectedDate;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 600,
            height: 100,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              controller: titleController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title of your task';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: 600,
            height: 100,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Task Subject',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              controller: textController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter text';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: 600,
            height: 100,
            child: TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            width: 600,
            height: 100,
            child: TextFormField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.forward,
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                    setState(() {
                      dateController.text = _selectedDate;
                    });
                  },
                ),
              ),
              controller: dateController,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
                setState(() {
                  dateController.text = _selectedDate;
                });
              },
              validator: (value) {
                if (DateTime.tryParse(value!) == null) {
                  return 'Please select date';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  context.read<TaskList>().addTask(
                        task: Task(
                          title: titleController.text,
                          text: textController.text,
                          description: descriptionController.text,
                          dueDate: DateTime.parse(_selectedDate),
                        ),
                      );
                }
                context.read<TaskList>().sortList();
                context.read<TaskList>().sortListByStatus();
              },
              child: const Text('Add task'),
            ),
          ),
        ],
      ),
    );
  }
}
