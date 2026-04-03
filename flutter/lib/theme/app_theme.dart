import 'package:flutter/material.dart';
import '../models/task_status.dart';
import '../models/task_priority.dart';

/// Custom app theme with vibrant, playful colors
class AppTheme {
  /// Primary vibrant coral color
  static const Color primary = Color(0xFFFF6B6B);
  
  /// Secondary teal color
  static const Color secondary = Color(0xFF4ECDC4);
  
  /// Accent amber/orange
  static const Color accent = Color(0xFFFFD93D);
  
  /// Accent violet
  static const Color violet = Color(0xFF6C5CE7);
  
  /// Status colors
  static const Color todoBlue = Color(0xFF3498DB);
  static const Color inProgressOrange = Color(0xFFF39C12);
  static const Color doneGreen = Color(0xFF27AE60);
  
  /// Priority colors
  static const Color lowPriorityBlue = Color(0xFF3498DB);
  static const Color mediumPriorityOrange = Color(0xFFF39C12);
  static const Color highPriorityRed = Color(0xFFE74C3C);
  
  /// Neutral colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMuted = Color(0xFF95A5A6);
  static const Color dividerColor = Color(0xFFECF0F1);
  
  /// Get light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: violet,
        surface: surfaceLight,
        background: backgroundLight,
        error: Color(0xFFE74C3C),
      ),
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDark,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textMuted,
        ),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 8,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
        extendedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0F0F0),
        selectedColor: secondary,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.8,
        space: 16,
      ),
    );
  }
  
  /// Get status color based on TaskStatus enum
  static Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return todoBlue;
      case TaskStatus.inProgress:
        return inProgressOrange;
      case TaskStatus.done:
        return doneGreen;
    }
  }
  
  /// Get status background color (light variant)
  static Color getStatusBackgroundColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return todoBlue.withOpacity(0.1);
      case TaskStatus.inProgress:
        return inProgressOrange.withOpacity(0.1);
      case TaskStatus.done:
        return doneGreen.withOpacity(0.1);
    }
  }
  
  /// Get priority color based on TaskPriority enum
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return lowPriorityBlue;
      case TaskPriority.medium:
        return mediumPriorityOrange;
      case TaskPriority.high:
        return highPriorityRed;
    }
  }
  
  /// Get priority background color (light variant)
  static Color getPriorityBackgroundColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return lowPriorityBlue.withOpacity(0.1);
      case TaskPriority.medium:
        return mediumPriorityOrange.withOpacity(0.1);
      case TaskPriority.high:
        return highPriorityRed.withOpacity(0.1);
    }
  }
}
