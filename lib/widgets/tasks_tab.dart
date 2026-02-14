// widgets/tasks_tab.dart
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TasksTab extends StatefulWidget {
  final List<Todo> todos;
  final Function(int, bool) onToggle;
  final Function(String) onCreateTask;
  final Function(int) onDeleteTask;

  const TasksTab({
    Key? key,
    required this.todos,
    required this.onToggle,
    required this.onCreateTask,
    required this.onDeleteTask,
  }) : super(key: key);

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  String _filter = 'all'; // all, completed, pending

  List<Todo> get _filteredTodos {
    if (_filter == 'completed') {
      return widget.todos.where((todo) => todo.completed).toList();
    } else if (_filter == 'pending') {
      return widget.todos.where((todo) => !todo.completed).toList();
    }
    return widget.todos;
  }

  int get _completedCount =>
      widget.todos.where((todo) => todo.completed).length;

  void _showCreateTaskDialog() {
    final TextEditingController taskController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_task,
                color: Colors.purpleAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Create New Task',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: taskController,
                autofocus: true,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  hintText: 'Enter your task here...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(
                      Icons.description_outlined,
                      color: Colors.purpleAccent.withOpacity(0.7),
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111328),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task description';
                  }
                  if (value.trim().length < 3) {
                    return 'Task must be at least 3 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final taskTitle = taskController.text.trim();
                Navigator.pop(context);
                widget.onCreateTask(taskTitle);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Create',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this task?\n\n"${todo.title}"',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDeleteTask(todo.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Statistics Card
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.2),
                    Colors.blueAccent.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Total',
                    widget.todos.length.toString(),
                    Colors.purpleAccent,
                  ),
                  _buildStatItem(
                    'Completed',
                    _completedCount.toString(),
                    Colors.greenAccent,
                  ),
                  _buildStatItem(
                    'Pending',
                    (widget.todos.length - _completedCount).toString(),
                    Colors.orangeAccent,
                  ),
                ],
              ),
            ),
            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', 'completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', 'pending'),
                ],
              ),
            ),
            // Tasks List
            Expanded(
              child: _filteredTodos.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 80, // Space for FAB
                      ),
                      itemCount: _filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = _filteredTodos[index];
                        return _buildTaskCard(todo);
                      },
                    ),
            ),
          ],
        ),
        // Floating Action Button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: _showCreateTaskDialog,
            backgroundColor: Colors.purpleAccent,
            icon: const Icon(Icons.add),
            label: const Text(
              'New Task',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.2),
                  Colors.blueAccent.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _filter == 'all' 
                ? 'No tasks yet' 
                : _filter == 'completed'
                    ? 'No completed tasks'
                    : 'No pending tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _filter == 'all'
                ? 'Tap the button below to create your first task'
                : 'Switch filters to see other tasks',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filter = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.6),
                      Colors.blueAccent.withOpacity(0.6),
                    ],
                  )
                : null,
            color: isSelected ? null : const Color(0xFF1D1E33),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.purpleAccent.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Todo todo) {
    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) async {
        _confirmDeleteTask(todo);
        return false; // Don't auto-dismiss, wait for confirmation
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: todo.completed
                ? Colors.greenAccent.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: todo.completed,
              onChanged: (value) {
                if (value != null) {
                  widget.onToggle(todo.id, value);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Colors.greenAccent,
              checkColor: const Color(0xFF0A0E21),
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 16,
              decoration: todo.completed ? TextDecoration.lineThrough : null,
              color: todo.completed
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: todo.completed
                      ? LinearGradient(
                          colors: [
                            Colors.greenAccent.withOpacity(0.3),
                            Colors.green.withOpacity(0.3),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Colors.orangeAccent.withOpacity(0.3),
                            Colors.orange.withOpacity(0.3),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  todo.completed ? 'Done' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: todo.completed ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDeleteTask(todo),
                tooltip: 'Delete task',
              ),
            ],
          ),
        ),
      ),
    );
  }
}