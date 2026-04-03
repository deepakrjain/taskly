import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/task.dart';

// API Service provider
final apiServiceProvider = Provider((ref) => ApiService());

// Tasks list state provider
final tasksProvider =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TasksNotifier(apiService);
});

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final ApiService _apiService;

  TasksNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  /// Load all tasks from API
  Future<void> loadTasks({String search = '', String status = ''}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _apiService.fetchTasks(searchQuery: search, statusFilter: status),
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
      final newTask = await _apiService.createTask(
        title: title,
        description: description,
        dueDate: dueDate,
        status: status,
        blockedBy: blockedBy,
        isRecurring: isRecurring,
        recurrenceType: recurrenceType,
      );

      // Reload tasks after creation
      await loadTasks();
      return newTask;
    } catch (e) {
      rethrow;
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
      final updatedTask = await _apiService.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        dueDate: dueDate,
        status: status,
        blockedBy: blockedBy,
        isRecurring: isRecurring,
        recurrenceType: recurrenceType,
      );

      // Reload tasks after update
      await loadTasks();
      return updatedTask;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _apiService.deleteTask(taskId);

      // Reload tasks after deletion
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  /// Reorder tasks
  Future<void> reorderTasks(List<String> taskIds) async {
    try {
      await _apiService.reorderTasks(taskIds);

      // Reload tasks after reordering
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  /// Filter tasks by search
  Future<void> searchTasks(String query) async {
    await loadTasks(search: query);
  }

  /// Filter tasks by status
  Future<void> filterByStatus(String status) async {
    await loadTasks(status: status);
  }
}

// Loading state provider for UI feedback during 2-second delays
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Current task being edited
final currentTaskProvider = StateProvider<Task?>((ref) => null);
