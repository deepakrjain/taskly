import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: TasklyApp()));
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      home: const TaskListScreen(),
    );
  }
}

