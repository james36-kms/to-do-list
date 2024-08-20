import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/task.dart';
import 'task_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TaskProvider()..loadTasks(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    TaskList(status: "To Do"),
    TaskList(status: "In Progress"),
    TaskList(status: "Done"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To Do'),
          BottomNavigationBarItem(
              icon: Icon(Icons.incomplete_circle), label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.done_all), label: 'Done'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
      backgroundColor: _selectedIndex == 0
          ? Colors.green
          : _selectedIndex == 1
              ? Colors.orangeAccent
              : Colors.lightBlue,
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    TextEditingController taskController = TextEditingController();
    String selectedStatus = "To Do";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Task Description'),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                    items: <String>['To Do', 'In Progress', 'Done']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                        Task(
                            description: taskController.text,
                            status: selectedStatus),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TaskList extends StatelessWidget {
  final String status;

  TaskList({required this.status});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks =
            taskProvider.tasks.where((task) => task.status == status).toList();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(tasks[index].description),
              subtitle: Text(tasks[index].status),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditTaskDialog(context, tasks[index],
                        taskProvider.tasks.indexOf(tasks[index])),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => taskProvider
                        .deleteTask(taskProvider.tasks.indexOf(tasks[index])),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    TextEditingController taskController =
        TextEditingController(text: task.description);
    String selectedStatus = task.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Task Description'),
                  ),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                    items: <String>['To Do', 'In Progress', 'Done']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Update'),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .updateTask(
                        Task(
                            description: taskController.text,
                            status: selectedStatus),
                        index,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
