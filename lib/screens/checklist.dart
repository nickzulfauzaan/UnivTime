import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univtime/utils/theme.dart';

class TaskModel extends ChangeNotifier {
  List<Task> tasks = [];
  String searchText = '';

  void addTask(String task) {
    tasks.add(Task(name: task, isCompleted: false));
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(int index) {
    tasks[index] = tasks[index].copyWith(isCompleted: !tasks[index].isCompleted);
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    _saveTasks();
    notifyListeners();
  }

  List<Task> getFilteredTasks() {
    if (searchText.isEmpty) return tasks;
    return tasks.where((t) => t.name.toLowerCase().contains(searchText.toLowerCase())).toList();
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks.map((t) => '${t.name}|${t.isCompleted ? 1 : 0}').toList());
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('tasks');
    if (data != null) {
      tasks = data.map((s) {
        final parts = s.split('|');
        return Task(name: parts[0], isCompleted: parts[1] == '1');
      }).toList();
      notifyListeners();
    }
  }
}

class Task {
  final String name;
  final bool isCompleted;

  Task({required this.name, required this.isCompleted});

  Task copyWith({bool? isCompleted}) {
    return Task(name: name, isCompleted: isCompleted ?? this.isCompleted);
  }
}

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  final TextEditingController _controller = TextEditingController();
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskModel>(context, listen: false)._loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          _buildAddTaskField(),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['All', 'Active', 'Completed'];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _filterIndex == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filterIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddTaskField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                hintText: 'Add a new task...',
                hintStyle: const TextStyle(color: AppColors.textTertiary),
                prefixIcon: const Icon(Icons.add_task, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _addTask(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _addTask,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskModel>(
      builder: (context, model, child) {
        final tasks = _getFilteredTasks(model);
        
        if (tasks.isEmpty) {
          return _buildEmptyState();
        }
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final originalIndex = model.tasks.indexOf(task);
            return _buildTaskItem(task, originalIndex, model);
          },
        );
      },
    );
  }

  List<Task> _getFilteredTasks(TaskModel model) {
    final allTasks = model.getFilteredTasks();
    switch (_filterIndex) {
      case 1:
        return allTasks.where((t) => !t.isCompleted).toList();
      case 2:
        return allTasks.where((t) => t.isCompleted).toList();
      default:
        return allTasks;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _filterIndex == 2 ? Icons.check_circle_outline : Icons.add_task,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _filterIndex == 2 
                ? 'No completed tasks' 
                : _filterIndex == 1 
                    ? 'No active tasks'
                    : 'No tasks yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a task to get started',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index, TaskModel model) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => model.toggleTask(index),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? AppColors.success : AppColors.divider,
                  width: 2,
                ),
                color: task.isCompleted ? AppColors.success : Colors.transparent,
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => model.deleteTask(index),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.textTertiary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    if (_controller.text.trim().isNotEmpty) {
      Provider.of<TaskModel>(context, listen: false).addTask(_controller.text);
      _controller.clear();
    }
  }
}
