import 'package:flutter/material.dart';
import '../../domain/entities/gamification.dart';
import '../../domain/repositories/gamification_repository.dart';

class MockGamificationRepository implements GamificationRepository {
  @override
  Future<GamificationProfile> getProfile(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return GamificationProfile(
      userId: userId,
      level: 12,
      levelTitle: 'Supplement Master',
      currentXp: 1200,
      xpToNextLevel: 3000, // 1200/3000 = 0.4 which matches 40% mastery
      badges: _getMockBadges(),
    );
  }

  @override
  Future<List<GamificationBadge>> getBadges(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockBadges();
  }

  List<GamificationBadge> _getMockBadges() {
    return [
      const GamificationBadge(
        id: '1',
        title: 'Early Bird',
        subtitle: 'Log morning stack before 9 AM',
        icon: Icons.light_mode,
        color: Colors.amber,
        isEarned: true,
        earnedDate: null,
        isLocked: false,
      ),
      const GamificationBadge(
        id: '2',
        title: 'Streak Master',
        subtitle: '7 Day Streak',
        icon: Icons.local_fire_department,
        color: Color(0xFFEC1380), // Primary Pink
        isEarned: true,
        earnedDate: null,
        isLocked: false,
      ),
      const GamificationBadge(
        id: '3',
        title: 'Safety First',
        subtitle: 'Check 1 interaction',
        icon: Icons.verified_user,
        color: Colors.blue,
        isEarned: true,
        earnedDate: null,
        isLocked: false,
      ),
      const GamificationBadge(
        id: '4',
        title: 'Focus Legend',
        subtitle: 'EARNED 2D AGO',
        icon: Icons
            .psychology, // Matches UI "military_tech" but name "Focus Legend"
        // In UI code it was military_tech for "Focus Legend" card, but psychology for "Focus Legend" recent win.
        // Let's standardise on military_tech for the main badge if that's what the card used?
        // Actually, let's use the ones from the grid to be consistent with the "Trophy Case"
        color: Colors.green, // from Recent Wins
        isEarned: true,
        earnedDate: null,
        isLocked: false,
      ),
      // From Grid
      const GamificationBadge(
        id: '5',
        title: '14-Day Rush',
        subtitle: 'EARNED OCT 12',
        icon: Icons.bolt,
        color: Colors.orange,
        isEarned: true,
        earnedDate: null,
        isLocked: false,
      ),
      const GamificationBadge(
        id: '6',
        title: 'Omega Master',
        subtitle: 'Take Omega-3 for 7 days',
        icon: Icons.set_meal,
        color: Colors.blue,
        isEarned: false,
        isLocked: true,
      ),
      const GamificationBadge(
        id: '7',
        title: 'Night Owl',
        subtitle: 'Log night stack before 10 PM',
        icon: Icons.dark_mode,
        color: Colors.indigo,
        isEarned: false,
        isLocked: true,
      ),
      const GamificationBadge(
        id: '8',
        title: 'Safety First II',
        subtitle: 'Check 5 interactions',
        icon: Icons.medical_services,
        color: Colors.red,
        isEarned: false,
        isLocked: true,
      ),
      const GamificationBadge(
        id: '9',
        title: 'Routine Pro',
        subtitle: 'Set up 3 custom stacks',
        icon: Icons.calendar_month,
        color: Colors.teal,
        isEarned: false,
        isLocked: true,
      ),
    ];
  }
}
