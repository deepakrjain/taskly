import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

// Shared preferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must override with actual instance');
});

// Drafts provider using StateNotifier
final draftsProvider = StateNotifierProvider<DraftsNotifier, Map<String, Task>>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return DraftsNotifier(prefs);
  },
);

class DraftsNotifier extends StateNotifier<Map<String, Task>> {
  static const String _storageKey = 'taskly_drafts';
  final SharedPreferences _prefs;

  DraftsNotifier(this._prefs) : super({}) {
    _loadDrafts();
  }

  /// Load drafts from local storage
  Future<void> _loadDrafts() async {
    try {
      final draftsJson = _prefs.getString(_storageKey);
      if (draftsJson != null) {
        final Map<String, dynamic> decodedData =
            jsonDecode(draftsJson) as Map<String, dynamic>;
        final drafts = <String, Task>{};

        decodedData.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            drafts[key] = Task.fromJson(value);
          }
        });

        state = drafts;
      }
    } catch (e) {
      state = {};
    }
  }

  /// Save a draft locally
  Future<void> saveDraft(Task task) async {
    try {
      final updatedDrafts = {...state, task.id: task};
      state = updatedDrafts;

      final draftsJson = jsonEncode(
        updatedDrafts.map((key, value) => MapEntry(key, value.toJson())),
      );
      await _prefs.setString(_storageKey, draftsJson);
    } catch (e) {
      // Error handling - could implement logger here
    }
  }

  /// Update an existing draft
  Future<void> updateDraft(String taskId, Task updatedTask) async {
    try {
      if (state.containsKey(taskId)) {
        final updatedDrafts = {...state, taskId: updatedTask};
        state = updatedDrafts;

        final draftsJson = jsonEncode(
          updatedDrafts.map((key, value) => MapEntry(key, value.toJson())),
        );
        await _prefs.setString(_storageKey, draftsJson);
      }
    } catch (e) {
      // Error handling - could implement logger here
    }
  }

  /// Remove a draft after successful sync
  Future<void> removeDraft(String taskId) async {
    try {
      final updatedDrafts = {...state};
      updatedDrafts.remove(taskId);
      state = updatedDrafts;

      final draftsJson = jsonEncode(
        updatedDrafts.map((key, value) => MapEntry(key, value.toJson())),
      );
      await _prefs.setString(_storageKey, draftsJson);
    } catch (e) {
      // Error handling - could implement logger here
    }
  }

  /// Clear all drafts
  Future<void> clearAllDrafts() async {
    try {
      state = {};
      await _prefs.remove(_storageKey);
    } catch (e) {
      // Error handling - could implement logger here
    }
  }

  /// Get a specific draft
  Task? getDraft(String taskId) => state[taskId];

  /// Check if a draft exists
  bool hasDraft(String taskId) => state.containsKey(taskId);

  /// Get all draft count
  int getDraftCount() => state.length;
}
