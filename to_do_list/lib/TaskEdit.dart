import 'package:assignment_4/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:assignment_4/tasks.dart';

class TaskEdit extends StatefulWidget {
  final int index;
  const TaskEdit({Key? key, required this.index}) : super(key: key);

  @override
  State<TaskEdit> createState() => _NewTaskEditState();
}

class _NewTaskEditState extends State<TaskEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Task',
        ),
      ),
      body: Center(
        child: MyCustomEditingForm(index: widget.index),
      ),
    );
  }
}

class MyCustomEditingForm extends StatefulWidget {
  final int index;
  const MyCustomEditingForm({Key? key, required this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyCustomEditingFormState();
}

class _MyCustomEditingFormState extends State<MyCustomEditingForm> {
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

  bool isSwitched = false;
  String textValue = "Task Will be Marked as Due";

  @override
  Widget build(BuildContext context) {
    List<Task> list = context.watch<TaskList>().getList();

    void toggleSwitch(bool value) {
      if (isSwitched == false) {
        setState(() {
          isSwitched = true;
          textValue = 'Task Will be Marked as Completed';
        });
      } else {
        setState(() {
          isSwitched = false;
          textValue = 'Task Will be Marked as Due';
        });
      }
    }

    titleController.text = list[widget.index].title;
    descriptionController.text = list[widget.index].description;
    textController.text = list[widget.index].text;
    dateController.text =
        DateFormat("yyyy-MM-dd").format(list[widget.index].dueDate);
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
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate(context);
                    setState(
                      () {
                        dateController.text = _selectedDate;
                      },
                    );
                  },
                ),
              ),
              controller: dateController,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
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
          Text(
            textValue,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          Switch(value: isSwitched, onChanged: toggleSwitch),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  context.read<TaskList>().updateTask(
                      id: list[widget.index].id,
                      title: titleController.text,
                      description: descriptionController.text,
                      text: textController.text,
                      dueDate: DateTime.parse(dateController.text),
                      status: isSwitched);
                }
                if (isSwitched) {
                  isSwitched = false;
                  context.read<TaskList>().setCompletedOn(widget.index);
                  context.read<TaskList>().setStatus(widget.index);
                  setState(() {});
                }
                context.read<TaskList>().refreshList();
                context.read<TaskList>().sortList();
                context.read<TaskList>().sortListByStatus();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
