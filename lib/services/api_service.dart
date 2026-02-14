// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/todo_model.dart';

class ApiService {
  // Using CORS proxy to fix web CORS issues
  // For mobile, this still works but is slower (use direct API when possible)
  static const String corsProxy = 'https://corsproxy.io/?';
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static String _buildUrl(String endpoint) {
    return '$corsProxy$baseUrl$endpoint';
  }

  // Fetch a single user by ID
  static Future<User> fetchUser(int userId) async {
    try {
      final url = _buildUrl('/users/$userId');
      print('Fetching user from: $url');
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Network error: $e');
    }
  }

  // Fetch all users
  static Future<List<User>> fetchAllUsers() async {
    try {
      final url = _buildUrl('/users');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Network error: $e');
    }
  }

  // Fetch todos for a specific user
  static Future<List<Todo>> fetchUserTodos(int userId) async {
    try {
      final url = _buildUrl('/users/$userId/todos');
      print('Fetching todos from: $url');
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Successfully fetched ${jsonData.length} todos');
        return jsonData.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching todos: $e');
      throw Exception('Network error: $e');
    }
  }

  // Fetch all todos
  static Future<List<Todo>> fetchAllTodos() async {
    try {
      final url = _buildUrl('/todos');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all todos: $e');
      throw Exception('Network error: $e');
    }
  }

  // Update todo completion status
  static Future<bool> updateTodoStatus(int todoId, bool completed) async {
    try {
      final url = _buildUrl('/todos/$todoId');
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'completed': completed}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update todo. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating todo: $e');
      throw Exception('Network error: $e');
    }
  }
}