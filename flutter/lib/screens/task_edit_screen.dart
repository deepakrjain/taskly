import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/task_status.dart';
import '../models/task_priority.dart';
import '../models/recurrence_type.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TaskEditScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskEditScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  ConsumerState<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends ConsumerState<TaskEditScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TaskStatus selectedStatus;
  late TaskPriority selectedPriority;
  late bool isRecurring;
  late RecurrenceType? selectedRecurrence;
  late DateTime? selectedDueDate;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedStatus = widget.task.status;
    selectedPriority = widget.task.priority;
    isRecurring = widget.task.isRecurring;
    selectedRecurrence = widget.task.recurrenceType;
    selectedDueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ref.read(tasksProvider.notifier).updateTask(
            taskId: widget.task.id,
            title: titleController.text,
            description: descriptionController.text,
            dueDate: selectedDueDate,
            status: selectedStatus.apiValue,
            priority: selectedPriority.apiValue,
            isRecurring: isRecurring,
            recurrenceType:
                isRecurring ? selectedRecurrence?.apiValue : null,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully! ✓'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = AppTheme.getStatusColor(selectedStatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Updating task (2 seconds)...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Description field
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter task description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),

                  // Status selector
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: TaskStatus.values.map((status) {
                        final isSelected = selectedStatus == status;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(status.displayName),
                            onSelected: (_) =>
                                setState(() => selectedStatus = status),
                            backgroundColor:
                                AppTheme.getStatusBackgroundColor(status),
                            selectedColor:
                                AppTheme.getStatusColor(status).withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Priority selector
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: TaskPriority.values.map((priority) {
                        final isSelected = selectedPriority == priority;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(priority.displayName),
                            onSelected: (_) =>
                                setState(() => selectedPriority = priority),
                            backgroundColor:
                                AppTheme.getPriorityBackgroundColor(priority),
                            selectedColor:
                                AppTheme.getPriorityColor(priority).withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Due date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      selectedDueDate != null
                          ? 'Due: ${selectedDueDate!.month}/${selectedDueDate!.day}/${selectedDueDate!.year}'
                          : 'No due date',
                    ),
                    trailing: selectedDueDate != null
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => selectedDueDate = null),
                          )
                        : null,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),

                  // Recurring toggle
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Recurring Task'),
                    value: isRecurring,
                    onChanged: (value) {
                      setState(() => isRecurring = value ?? false);
                    },
                  ),

                  // Recurrence type selector
                  if (isRecurring)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: DropdownButtonFormField<RecurrenceType>(
                        value: selectedRecurrence ?? RecurrenceType.daily,
                        decoration: InputDecoration(
                          labelText: 'Repeat',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: RecurrenceType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedRecurrence = value);
                        },
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveTask,
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
