// screens/user_profile_page.dart
import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../main.dart';
import '../widgets/profile_tab.dart';
import '../widgets/tasks_tab.dart';

class UserProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onLogout;
  final Function(String) onUsernameUpdate;

  const UserProfilePage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.onLogout,
    required this.onUsernameUpdate,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _currentUserName;
  
  // State variables
  bool _isLoading = false;
  List<Todo> _todos = [];
  
  // Store tasks per user (in production, use a real database)
  static final Map<String, List<Todo>> _userTasks = {};
  static int _nextTodoId = 1000; // Start from 1000 to avoid conflicts with API IDs

  @override
  void initState() {
    super.initState();
    _currentUserName = widget.userName;
    _tabController = TabController(length: 2, vsync: this);
    _loadUserTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load tasks for current user
  void _loadUserTasks() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_userTasks.containsKey(widget.userEmail)) {
        setState(() {
          _todos = List.from(_userTasks[widget.userEmail]!);
          _isLoading = false;
        });
      } else {
        // Initialize empty task list for new user
        _userTasks[widget.userEmail] = [];
        setState(() {
          _todos = [];
          _isLoading = false;
        });
      }
    });
  }

  // Save tasks for current user
  void _saveUserTasks() {
    _userTasks[widget.userEmail] = List.from(_todos);
  }

  // Handle todo toggle
  void _handleTodoToggle(int todoId, bool completed) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == todoId);
      if (index != -1) {
        _todos[index].completed = completed;
        _saveUserTasks();
      }
    });
  }

  // Handle create task
  void _handleCreateTask(String title) {
    final newTodo = Todo(
      userId: 0, // Local user
      id: _nextTodoId++,
      title: title,
      completed: false,
    );

    setState(() {
      _todos.insert(0, newTodo); // Add to beginning of list
      _saveUserTasks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task created successfully!'),
        backgroundColor: Colors.greenAccent.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Handle delete task
  void _handleDeleteTask(int todoId) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == todoId);
      _saveUserTasks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted successfully!'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Handle username update
  void _handleUsernameUpdate(String newName) {
    setState(() {
      _currentUserName = newName;
    });
    widget.onUsernameUpdate(newName);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Username updated successfully!'),
        backgroundColor: Colors.greenAccent.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Handle logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
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
              Navigator.pop(context); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              _buildCustomAppBar(),
              // Body
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Title only, no back button
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.purpleAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(
                icon: Icon(Icons.person),
                text: 'Profile',
              ),
              Tab(
                icon: Icon(Icons.task_alt),
                text: 'Tasks',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        ProfileTab(
          userName: _currentUserName,
          userEmail: widget.userEmail,
          onLogout: _handleLogout,
          onUsernameUpdate: _handleUsernameUpdate,
        ),
        TasksTab(
          todos: _todos,
          onToggle: _handleTodoToggle,
          onCreateTask: _handleCreateTask,
          onDeleteTask: _handleDeleteTask,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.8),
                  Colors.blueAccent.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your profile...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}