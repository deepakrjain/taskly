enum FilterType {
  all,
  myDay,
  upcoming,
  overdue,
  completed,
}

extension FilterTypeExtension on FilterType {
  String get displayName {
    switch (this) {
      case FilterType.all:
        return 'All';
      case FilterType.myDay:
        return 'My Day';
      case FilterType.upcoming:
        return 'Upcoming';
      case FilterType.overdue:
        return 'Overdue';
      case FilterType.completed:
        return 'Completed';
    }
  }

  String get label {
    switch (this) {
      case FilterType.all:
        return '📋';
      case FilterType.myDay:
        return '📅';
      case FilterType.upcoming:
        return '⏰';
      case FilterType.overdue:
        return '⚠️';
      case FilterType.completed:
        return '✅';
    }
  }
}
