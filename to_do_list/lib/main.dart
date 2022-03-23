import 'package:assignment_4/NewTask.dart';
import 'package:assignment_4/TaskInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_4/tasks.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tasks'),
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
  @override
  Widget build(BuildContext context) {
    return context.watch<TaskList>().isEmpty()
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
              ? const SizedBox(
                  width: 60,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                )
              : context
                      .watch<TaskList>()
                      .getDueDate(index)
                      .isBefore(DateTime.now())
                  ? SizedBox(
                      width: 60,
                      child: Row(
                        children: [
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
                      width: 60,
                      child: IconButton(
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
              builder: (context) => NewTask(),
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
