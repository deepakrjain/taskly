enum RecurrenceType {
  daily,
  weekly,
}

extension RecurrenceTypeExtension on RecurrenceType {
  String get displayName {
    switch (this) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
    }
  }

  String get apiValue {
    switch (this) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
    }
  }
}

RecurrenceType recurrenceTypeFromApiValue(String value) {
  switch (value) {
    case 'Daily':
      return RecurrenceType.daily;
    case 'Weekly':
      return RecurrenceType.weekly;
    default:
      return RecurrenceType.daily;
  }
}
