import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/gamification.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/gamification_repository.dart';

class FirebaseGamificationRepository implements GamificationRepository {
  final FirebaseFirestore _firestore;

  FirebaseGamificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Master list of all available badges
  static const List<GamificationBadge> _badgeDefinitions = [
    GamificationBadge(
      id: 'early_bird',
      title: 'Early Bird',
      subtitle: 'Log morning stack before 9 AM',
      icon: Icons.wb_sunny,
      color: Colors.amber,
    ),
    GamificationBadge(
      id: '7_day_warrior', // Was '2' or 'Streak Master' in mock
      title: 'Streak Master',
      subtitle: 'Maintain a 7-day streak',
      icon: Icons.local_fire_department,
      color: Color(0xFFEC1380),
    ),
    GamificationBadge(
      id: 'safety_first', // Was '3'
      title: 'Safety First',
      subtitle: 'Check 1 interaction',
      icon: Icons.verified_user,
      color: Colors.blue,
    ),
    GamificationBadge(
      id: 'focus_master', // Was '4'
      title: 'Focus Legend',
      subtitle: 'Reach Level 5',
      icon: Icons.psychology,
      color: Colors.purple,
    ),
    GamificationBadge(
      id: 'alpha_hero',
      title: 'Alpha Hero',
      subtitle: 'Early app supporter',
      icon: Icons.auto_awesome,
      color: Color(0xFFFFD700),
    ),
    // ... Add others as needed, keeping it simple for now
  ];

  @override
  Future<GamificationProfile> getProfile(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final user = User.fromJson(userDoc.data()!);
      final badges = await getBadges(userId, user: user);

      return GamificationProfile(
        userId: userId,
        level: user.level,
        levelTitle: _getLevelTitle(user.level),
        currentXp: user.xp,
        xpToNextLevel: user.level * 1000,
        badges: badges,
      );
    } catch (e) {
      debugPrint('Error fetching gamification profile: $e');
      rethrow;
    }
  }

  @override
  Future<List<GamificationBadge>> getBadges(String userId, {User? user}) async {
    // If user object not provided, fetch it
    if (user == null) {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return [];
      user = User.fromJson(doc.data()!);
    }

    final unlockedIds = user.unlockedAchievements;

    return _badgeDefinitions.map((def) {
      final isEarned = unlockedIds.contains(def.id);
      return def.copyWith(
        isEarned: isEarned,
        isLocked: !isEarned,
        // earnedDate: ... (If we tracked DATE of unlock, we'd need a Map<String, DateTime> in User, currently just List<String>)
      );
    }).toList();
  }

  String _getLevelTitle(int level) {
    if (level < 5) return 'Novice';
    if (level < 10) return 'Apprentice';
    if (level < 20) return 'Focus Adept';
    if (level < 50) return 'Mental Warrior';
    return 'Zen Master';
  }
}
