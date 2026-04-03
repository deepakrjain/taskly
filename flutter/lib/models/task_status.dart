enum TaskStatus {
  todo,
  inProgress,
  done,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }

  String get apiValue {
    switch (this) {
      case TaskStatus.todo:
        return 'To-Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
    }
  }
}

TaskStatus taskStatusFromApiValue(String value) {
  switch (value) {
    case 'To-Do':
      return TaskStatus.todo;
    case 'In Progress':
      return TaskStatus.inProgress;
    case 'Done':
      return TaskStatus.done;
    default:
      return TaskStatus.todo;
  }
}
