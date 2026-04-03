import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/task_status.dart';
import '../models/task_priority.dart';
import '../models/filter_type.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/search_filter_bar.dart';
import 'task_edit_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String searchQuery = '';
  String statusFilter = '';
  FilterType selectedFilter = FilterType.all;

  @override
  Widget build(BuildContext context) {
    final tasksAsyncValue = ref.watch(tasksProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taskly',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          SearchFilterBar(
            initialSearchQuery: searchQuery,
            initialStatusFilter: statusFilter,
            onSearchChanged: (query) async {
              setState(() => searchQuery = query);
              await ref.read(tasksProvider.notifier).searchTasks(query);
            },
            onStatusFilterChanged: (status) async {
              setState(() => statusFilter = status);
              await ref.read(tasksProvider.notifier).filterByStatus(status);
            },
          ),
          // Quick filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: FilterType.values.map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(filter.displayName),
                      avatar: Text(filter.label),
                      onSelected: (_) {
                        setState(() => selectedFilter = filter);
                        _applyQuickFilter(ref, filter);
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      labelStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Task list
          Expanded(
            child: tasksAsyncValue.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading tasks',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.refresh(tasksProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to Taskly',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty || statusFilter.isNotEmpty
                              ? 'No tasks match your filters'
                              : 'Create your first task to get started',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ReorderableListView(
                  padding: const EdgeInsets.all(16),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    _reorderTasks(ref, tasks, oldIndex, newIndex);
                  },
                  children: [
                    for (int index = 0; index < tasks.length; index++)
                      Container(
                        key: ValueKey(tasks[index].id),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: _TaskCard(
                          task: tasks[index],
                          ref: ref,
                          onEditPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TaskEditScreen(task: tasks[index]),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () {
                _showCreateTaskDialog(context, ref);
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  void _reorderTasks(WidgetRef ref, List<Task> tasks, int oldIndex, int newIndex) async {
    try {
      // Create new ordered list with reordered task IDs
      final reorderedIds = tasks.map((t) => t.id).toList();
      reorderedIds.removeAt(oldIndex);
      reorderedIds.insert(newIndex, tasks[oldIndex].id);
      
      // Send reorder request to backend
      await ref.read(tasksProvider.notifier).reorderTasks(reorderedIds);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error reordering: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyQuickFilter(WidgetRef ref, FilterType filter) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    try {
      switch (filter) {
        case FilterType.all:
          // Reset to show all tasks
          setState(() {
            searchQuery = '';
            statusFilter = '';
          });
          await ref.read(tasksProvider.notifier).loadTasks();
          break;
        case FilterType.myDay:
          // Show tasks due today
          final tasks = ref.read(tasksProvider).value ?? [];
          final todayTasks = tasks.where((t) {
            if (t.dueDate == null) return false;
            final taskDate = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
            return taskDate == today && t.status != TaskStatus.done;
          }).toList();
          // Update search to filter locally
          setState(() => searchQuery = 'due-today');
          break;
        case FilterType.upcoming:
          // Show tasks due in future
          setState(() => searchQuery = 'upcoming');
          break;
        case FilterType.overdue:
          // Show overdue tasks
          final tasks = ref.read(tasksProvider).value ?? [];
          final overdueTasks = tasks.where((t) {
            if (t.dueDate == null) return false;
            final taskDate = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
            return taskDate.isBefore(today) && t.status != TaskStatus.done;
          }).toList();
          setState(() => searchQuery = 'overdue');
          break;
        case FilterType.completed:
          // Show completed tasks only
          await ref.read(tasksProvider.notifier).filterByStatus('Done');
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying filter: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCreateTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    var isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Task',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: 'Task Title *',
                      hintText: 'Enter task title',
                      prefixIcon: Icon(Icons.check_circle_outline,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter task description',
                      prefixIcon: Icon(Icons.description_outlined,
                          color: Theme.of(context).primaryColor),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    Column(
                      children: [
                        SizedBox(
                          height: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Creating task...',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading ? null : () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: isLoading ? Colors.grey : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (titleController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Task title cannot be empty'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                setState(() => isLoading = true);

                                try {
                                  await ref.read(tasksProvider.notifier).createTask(
                                        title: titleController.text,
                                        description: descriptionController.text,
                                      );

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Task created successfully! ✓'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Color(0xFF27AE60),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                        icon: const Icon(Icons.add),
                        label: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final WidgetRef ref;
  final VoidCallback onEditPressed;

  const _TaskCard({
    required this.task,
    required this.ref,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppTheme.getStatusColor(task.status);
    final statusBgColor = AppTheme.getStatusBackgroundColor(task.status);
    final priorityColor = AppTheme.getPriorityColor(task.priority);
    final priorityBgColor = AppTheme.getPriorityBackgroundColor(task.priority);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priorityColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(isDarkMode ? 0.15 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEditPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.drag_handle,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.description.isNotEmpty) ...
                          [
                            const SizedBox(height: 6),
                            Text(
                              task.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDarkMode 
                                  ? Colors.grey[400] 
                                  : Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.status.displayName,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: priorityBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          task.priority.displayName,
                          style: TextStyle(
                            color: priorityColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (task.dueDate != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${task.dueDate!.month}/${task.dueDate!.day}/${task.dueDate!.year}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.amber[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: onEditPressed,
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Edit task',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteConfirmation(context),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Delete task',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Task?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${task.title}"? This cannot be undone.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      try {
                        await ref.read(tasksProvider.notifier).deleteTask(task.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task deleted successfully ✓'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color(0xFF27AE60),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
