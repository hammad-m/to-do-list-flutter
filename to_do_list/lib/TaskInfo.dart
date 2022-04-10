import 'dart:html';
import 'package:assignment_4/TaskEdit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/tasks.dart';
import 'package:provider/provider.dart';

import 'dialog.dart';

class TaskInfo extends StatefulWidget {
  final int index;
  const TaskInfo({Key? key, required this.index}) : super(key: key);

  @override
  State<TaskInfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  SizedBox showDueDate() {
    return SizedBox(
      width: 600,
      height: 50,
      child: Text(
        'Due Date: ' +
            DateFormat("yyyy-MM-dd")
                .format(context.watch<TaskList>().getDueDate(widget.index))
                .toString(),
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<TaskList>().getTitle(widget.index)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<TaskList>().sortList();
            context.read<TaskList>().sortListByStatus();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 600,
              height: 50,
              child: Text(context.watch<TaskList>().getSampleText(widget.index),
                  style: Theme.of(context).textTheme.headline6),
            ),
            SizedBox(
              width: 600,
              height: 50,
              child: Text(
                  context.watch<TaskList>().getDescription(widget.index),
                  style: Theme.of(context).textTheme.headline6),
            ),
            showDueDate(),
            context.watch<TaskList>().getStatus(widget.index)
                ? Column(
                    children: [
                      SizedBox(
                        width: 600,
                        height: 50,
                        child: Text(
                          'You marked this task as done on ' +
                              DateFormat(("yyyy-MM-dd"))
                                  .format(context
                                      .watch<TaskList>()
                                      .getCompletionDate(widget.index))
                                  .toString(),
                          style: const TextStyle(
                              color: Colors.green, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, onPrimary: Colors.white),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskEdit(index: widget.index),
                              ),
                            ),
                          },
                          child: const Text('Edit Task'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red, onPrimary: Colors.white),
                          onPressed: () async {
                            if (await Dialogs.showDeleteConfirmationDialog(
                                context)) {
                              context.read<TaskList>().deleteTask(widget.index);
                              Navigator.of(context).pop();
                            } else {
                              //do nothing
                            }
                          },
                          child: const Text('Delete Task'),
                        ),
                      ),
                    ],
                  )
                : context
                        .watch<TaskList>()
                        .getDueDate(widget.index)
                        .isBefore(DateTime.now())
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 600,
                            height: 50,
                            child: Text(
                              'Due Date has passed',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white),
                              onPressed: () {
                                context
                                    .read<TaskList>()
                                    .setCompletedOn(widget.index);
                                context
                                    .read<TaskList>()
                                    .setStatus(widget.index);
                                setState(() {});
                              },
                              child: const Text('Mark as Done'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskEdit(index: widget.index),
                                  ),
                                ),
                              },
                              child: const Text('Edit Task'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red, onPrimary: Colors.white),
                              onPressed: () async {
                                if (await Dialogs.showDeleteConfirmationDialog(
                                    context)) {
                                  context
                                      .read<TaskList>()
                                      .deleteTask(widget.index);
                                  Navigator.of(context).pop();
                                } else {
                                  //do nothing
                                }
                              },
                              child: const Text('Delete Task'),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.white),
                                onPressed: () {
                                  context
                                      .read<TaskList>()
                                      .setCompletedOn(widget.index);
                                  context
                                      .read<TaskList>()
                                      .setStatus(widget.index);
                                  setState(() {});
                                },
                                child: const Text('Mark as Done'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white),
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskEdit(index: widget.index),
                                  ),
                                ),
                              },
                              child: const Text('Edit Task'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red, onPrimary: Colors.white),
                              onPressed: () async {
                                if (await Dialogs.showDeleteConfirmationDialog(
                                    context)) {
                                  context
                                      .read<TaskList>()
                                      .deleteTask(widget.index);
                                  Navigator.of(context).pop();
                                } else {
                                  //do nothing
                                }
                              },
                              child: const Text('Delete Task'),
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
