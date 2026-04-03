import 'package:dio/dio.dart';
import '../models/task.dart';

class ApiService {
  late Dio _dio;
  static const String baseUrl = 'http://localhost:8000';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );
  }

  /// Create a new task
  Future<Task> createTask({
    required String title,
    required String description,
    DateTime? dueDate,
    String? status,
    String? blockedBy,
    bool isRecurring = false,
    String? recurrenceType,
  }) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: {
          'title': title,
          'description': description,
          'due_date': dueDate?.toIso8601String(),
          'status': status ?? 'To-Do',
          'blocked_by': blockedBy,
          'is_recurring': isRecurring,
          'recurrence_type': recurrenceType,
        },
      );

      if (response.statusCode == 201) {
        return Task.fromJson(response.data);
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error creating task: ${e.message}');
    }
  }

  /// Fetch all tasks with optional filters
  Future<List<Task>> fetchTasks({
    String searchQuery = '',
    String statusFilter = '',
  }) async {
    try {
      final response = await _dio.get(
        '/tasks',
        queryParameters: {
          if (searchQuery.isNotEmpty) 'search': searchQuery,
          if (statusFilter.isNotEmpty) 'status': statusFilter,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((task) => Task.fromJson(task as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to fetch tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching tasks: ${e.message}');
    }
  }

  /// Fetch a single task by ID
  Future<Task> fetchTask(String taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId');

      if (response.statusCode == 200) {
        return Task.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching task: ${e.message}');
    }
  }

  /// Update an existing task
  Future<Task> updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? dueDate,
    String? status,
    String? blockedBy,
    bool? isRecurring,
    String? recurrenceType,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (dueDate != null) data['due_date'] = dueDate.toIso8601String();
      if (status != null) data['status'] = status;
      if (blockedBy != null) data['blocked_by'] = blockedBy;
      if (isRecurring != null) data['is_recurring'] = isRecurring;
      if (recurrenceType != null) data['recurrence_type'] = recurrenceType;

      final response = await _dio.put(
        '/tasks/$taskId',
        data: data,
      );

      if (response.statusCode == 200) {
        return Task.fromJson(response.data);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error updating task: ${e.message}');
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      final response = await _dio.delete('/tasks/$taskId');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting task: ${e.message}');
    }
  }

  /// Reorder tasks via drag and drop
  Future<void> reorderTasks(List<String> taskIds) async {
    try {
      final response = await _dio.patch(
        '/tasks/reorder',
        data: {
          'task_ids': taskIds,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reorder tasks: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error reordering tasks: ${e.message}');
    }
  }

  /// Check API health
  Future<bool> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
