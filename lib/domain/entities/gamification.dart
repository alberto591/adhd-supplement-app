import 'package:flutter/material.dart';

class GamificationBadge {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon; // Storing IconData for now as per current UI usage
  final Color color;
  final bool isEarned;
  final DateTime? earnedDate;
  final bool isLocked; // UI has lock state logic

  const GamificationBadge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isEarned = false,
    this.earnedDate,
    this.isLocked = true,
  });

  GamificationBadge copyWith({
    String? id,
    String? title,
    String? subtitle,
    IconData? icon,
    Color? color,
    bool? isEarned,
    DateTime? earnedDate,
    bool? isLocked,
  }) {
    return GamificationBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isEarned: isEarned ?? this.isEarned,
      earnedDate: earnedDate ?? this.earnedDate,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class GamificationProfile {
  final String userId;
  final int level;
  final String levelTitle; // e.g. "Supplement Master"
  final int currentXp;
  final int xpToNextLevel;
  final List<GamificationBadge> badges;

  const GamificationProfile({
    required this.userId,
    required this.level,
    required this.levelTitle,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.badges,
  });

  // Helpers for progress
  double get progress => currentXp / xpToNextLevel;
  int get earnedBadgesCount => badges.where((b) => b.isEarned).length;
  int get totalBadgesCount => badges.length;
}
