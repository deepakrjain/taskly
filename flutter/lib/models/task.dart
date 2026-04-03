import 'package:uuid/uuid.dart';
import 'task_status.dart';
import 'recurrence_type.dart';
import 'task_priority.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final String? blockedBy;
  final int orderIndex;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    String? id,
    required this.title,
    required this.description,
    this.dueDate,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    this.blockedBy,
    this.orderIndex = 0,
    this.isRecurring = false,
    this.recurrenceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      status: taskStatusFromApiValue(json['status'] ?? 'To-Do'),
      priority: priorityFromString(json['priority'] ?? 'Medium'),
      blockedBy: json['blocked_by'],
      orderIndex: json['order_index'] ?? 0,
      isRecurring: json['is_recurring'] ?? false,
      recurrenceType: json['recurrence_type'] != null
          ? recurrenceTypeFromApiValue(json['recurrence_type'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate?.toIso8601String(),
      'status': status.apiValue,
      'priority': priority.apiValue,
      'blocked_by': blockedBy,
      'order_index': orderIndex,
      'is_recurring': isRecurring,
      'recurrence_type': recurrenceType?.apiValue,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
    String? blockedBy,
    int? orderIndex,
    bool? isRecurring,
    RecurrenceType? recurrenceType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      blockedBy: blockedBy ?? this.blockedBy,
      orderIndex: orderIndex ?? this.orderIndex,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status)';
  }
}
