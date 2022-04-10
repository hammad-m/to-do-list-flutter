import 'package:assignment_4/NewTask.dart';
import 'package:assignment_4/TaskInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_4/tasks.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "",
        authDomain: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: ""),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskList()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MyHomePage(title: 'Assignment 5');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    showLoading();
  }

  void showLoading() async {
    // Load from Firebase
    context.read<TaskList>().refreshList();
    // delay(Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 3));
    _isLoading = false;
    // wait for the data to load
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : context.watch<TaskList>().isEmpty()
            ? noTaskScreen()
            : withTaskScreen();
  }

  Scaffold withTaskScreen() {
    List<Task> list = context.watch<TaskList>().getList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (
          context,
          index,
        ) =>
            ListTile(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskInfo(
                  index: index,
                ),
              ),
            ),
          },
          title: Text(list[index].title),
          subtitle: Text(
            'Due Date: ' +
                (DateFormat("yyyy-MM-dd")
                    .format(list[index].dueDate)
                    .toString()),
          ),
          trailing: list[index].status
              ? SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            if (await Dialogs.showDeleteConfirmationDialog(
                                context)) {
                              context.read<TaskList>().deleteTask(index);
                            } else {
                              //do nothing
                            }
                          },
                          icon: const Icon(Icons.delete_forever)),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                )
              : context
                      .watch<TaskList>()
                      .getDueDate(index)
                      .isBefore(DateTime.now())
                  ? SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (await Dialogs.showDeleteConfirmationDialog(
                                    context)) {
                                  context.read<TaskList>().deleteTask(index);
                                } else {
                                  //do nothing
                                }
                              },
                              icon: const Icon(Icons.delete_forever)),
                          IconButton(
                            onPressed: () {
                              context.read<TaskList>().setCompletedOn(index);
                              context.read<TaskList>().setStatus(index);
                              context.read<TaskList>().sortList();
                              context.read<TaskList>().sortListByStatus();
                              setState(() {});
                            },
                            icon: const Icon(Icons.circle_outlined),
                          ),
                          Container(
                            width: 15,
                            height: 45,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (await Dialogs.showDeleteConfirmationDialog(
                                    context)) {
                                  context.read<TaskList>().deleteTask(index);
                                } else {
                                  //do nothing
                                }
                              },
                              icon: const Icon(Icons.delete_forever)),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                context.read<TaskList>().setCompletedOn(index);
                                context.read<TaskList>().setStatus(index);
                                context.read<TaskList>().sortList();
                                context.read<TaskList>().sortListByStatus();
                              });
                            },
                            icon: const Icon(Icons.circle_outlined),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTask(),
            ),
          );
        },
      ),
    );
  }

  Scaffold noTaskScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Text(
                'You have no Pending Tasks',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewTask()),
                  );
                },
                child: const Text('Add a new Task'))
          ],
        ),
      ),
    );
  }
}
