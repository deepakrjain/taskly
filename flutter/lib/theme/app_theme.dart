import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      
      // Text theme with Google Fonts (Poppins)
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMuted,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
          labelMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textMuted,
          ),
        ),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
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
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
        hintStyle: GoogleFonts.poppins(
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
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 4,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0F0F0),
        selectedColor: secondary,
        labelStyle: GoogleFonts.poppins(
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
  
  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'to-do':
        return todoBlue;
      case 'in progress':
        return inProgressOrange;
      case 'done':
        return doneGreen;
      default:
        return todoBlue;
    }
  }
  
  /// Get status background color (light variant)
  static Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'to-do':
        return todoBlue.withOpacity(0.1);
      case 'in progress':
        return inProgressOrange.withOpacity(0.1);
      case 'done':
        return doneGreen.withOpacity(0.1);
      default:
        return todoBlue.withOpacity(0.1);
    }
  }
}
