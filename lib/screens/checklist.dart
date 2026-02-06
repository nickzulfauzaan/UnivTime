import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univtime/widgets/header.dart';

class TaskModel extends ChangeNotifier {
  List<Task> tasks = [];
  String searchText = '';

  void addTask(String task) {
    tasks.add(Task(name: task, isCompleted: false));
    _saveTasks();
    notifyListeners();
  }

  void completeTask(int originalIndex) {
    final index = _findFilteredIndex(originalIndex);
    tasks[index] =
        tasks[index].copyWith(isCompleted: !tasks[index].isCompleted);
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(int originalIndex) {
    final index = _findFilteredIndex(originalIndex);
    tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  int _findFilteredIndex(int originalIndex) {
    final filteredTasks = _getFilteredTasks();
    return tasks.indexOf(filteredTasks[originalIndex]);
  }

  List<Task> _getFilteredTasks() {
    return tasks.where((task) => task.name.contains(searchText)).toList();
  }

  // Save tasks to SharedPreferences
  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> serializedTasks = tasks
        .map((Task task) =>
            '${task.name}|${task.isCompleted ? 1 : 0}|${task.dueDateTime?.millisecondsSinceEpoch ?? 0}')
        .toList();
    prefs.setStringList('tasks', serializedTasks);
  }

  // Load tasks from SharedPreferences
  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? serializedTasks = prefs.getStringList('tasks');
    if (serializedTasks != null) {
      tasks = serializedTasks
          .map((String serialized) => _deserializeTask(serialized))
          .toList();
      notifyListeners();
    }
  }

  // Convert Task to a serializable map
  Task _deserializeTask(String serialized) {
    final List<String> parts = serialized.split('|');
    return Task(
      name: parts[0],
      isCompleted: parts[1] == '1',
      dueDateTime: DateTime.fromMillisecondsSinceEpoch(int.parse(parts[2])),
    );
  }
}

class Task {
  final String name;
  final bool isCompleted;
  final DateTime? dueDateTime;

  Task({required this.name, required this.isCompleted, this.dueDateTime});

  Task copyWith({String? name, bool? isCompleted, DateTime? dueDateTime}) {
    return Task(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDateTime: dueDateTime ?? this.dueDateTime,
    );
  }
}

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load tasks when the widget initializes
    Provider.of<TaskModel>(context, listen: false)._loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF12171D),
      appBar: AppBar(
        backgroundColor: Color(0xFF12171D),
        title: Header(),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: taskController,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                  hintText: "Add a task",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 248, 248, 248)),
                  prefixIcon: Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 254, 254, 254),
                    size: 26.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      if (taskController.text.trim().isNotEmpty) {
                        Provider.of<TaskModel>(context, listen: false)
                            .addTask(taskController.text);
                        taskController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    Provider.of<TaskModel>(context, listen: false).searchText =
                        value;
                  });
                },
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                  hintText: "Search tasks",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 248, 248, 248)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 254, 254, 254),
                    size: 26.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<TaskModel>(
                builder: (context, taskModel, child) {
                  final filteredTasks = taskModel._getFilteredTasks();

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: Row(
                            children: [
                              Checkbox(
                                value: task.isCompleted,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    taskModel.completeTask(index);
                                  }
                                },
                                activeColor: Colors.white,
                                checkColor:
                                    Colors.blue, // Color of the checkmark
                              ),
                              Text(
                                task.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.white,
                            onPressed: () {
                              taskModel.deleteTask(index);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
