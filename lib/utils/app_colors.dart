import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color accent = Color(0xFFFF6B6B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  
  // Card and container colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color containerLight = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
