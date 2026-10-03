import 'package:flutter/material.dart';

/// CampusFind brand color palette
class AppColors {
  AppColors._();

  // Primary – Deep Indigo/Navy
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF3949AB);
  static const Color primaryDark = Color(0xFF0D1642);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Accent – Teal
  static const Color accent = Color(0xFF00897B);
  static const Color accentLight = Color(0xFF4DB6AC);
  static const Color accentDark = Color(0xFF00695C);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Semantic status colors
  static const Color success = Color(0xFF2E7D32);   // Returned / Found
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color pending = Color(0xFFF57F17);   // Pending / In progress
  static const Color pendingLight = Color(0xFFFFF8E1);
  static const Color lost = Color(0xFFC62828);      // Lost / Error
  static const Color lostLight = Color(0xFFFFEBEE);
  static const Color claimed = Color(0xFF1565C0);   // Claimed
  static const Color claimedLight = Color(0xFFE3F2FD);

  // Neutrals
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  static const Color divider = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Shadows
  static const Color shadow = Color(0x1A000000);
}
