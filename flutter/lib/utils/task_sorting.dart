import '../models/task.dart';
import '../models/task_priority.dart';

/// Sorts tasks by:
/// 1. Due date (nearest first) - if task has a due date
/// 2. Priority (High > Medium > Low) - for tasks without due date
List<Task> sortTasksByDueDateAndPriority(List<Task> tasks) {
  final today = DateTime.now();
  
  tasks.sort((a, b) {
    // Both have due dates - sort by nearest date
    if (a.dueDate != null && b.dueDate != null) {
      return a.dueDate!.compareTo(b.dueDate!);
    }
    
    // Only a has due date - put it first
    if (a.dueDate != null && b.dueDate == null) {
      return -1;
    }
    
    // Only b has due date - put it first
    if (a.dueDate == null && b.dueDate != null) {
      return 1;
    }
    
    // Neither has due date - sort by priority
    return _priorityValue(a.priority).compareTo(_priorityValue(b.priority));
  });
  
  return tasks;
}

/// Returns numeric value for priority (higher = higher priority)
int _priorityValue(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return 3;
    case TaskPriority.medium:
      return 2;
    case TaskPriority.low:
      return 1;
  }
}
