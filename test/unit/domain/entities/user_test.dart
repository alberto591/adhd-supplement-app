import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    final baseUser = User(
      id: '123',
      email: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
    );

    test('should copyWith unlockedAchievements correctly', () {
      final updatedUser = baseUser.copyWith(
        unlockedAchievements: ['badge_1', 'badge_2'],
      );

      expect(updatedUser.unlockedAchievements.length, 2);
      expect(updatedUser.unlockedAchievements, contains('badge_1'));
      expect(updatedUser.unlockedAchievements, contains('badge_2'));
    });

    test('should serialize unlockedAchievements to JSON', () {
      final user = baseUser.copyWith(
        unlockedAchievements: ['badge_1'],
        level: 5,
        xp: 500,
      );

      final json = user.toJson();

      expect(json['unlockedAchievements'], isA<List<String>>());
      expect(json['unlockedAchievements'], contains('badge_1'));
      expect(json['level'], 5);
      expect(json['xp'], 500);
    });

    test('should deserialize unlockedAchievements from JSON', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'createdAt': '2023-01-01T00:00:00.000',
        'level': 2,
        'xp': 100,
        'unlockedAchievements': ['badge_3', 'badge_4'],
      };

      final user = User.fromJson(json);

      expect(user.level, 2);
      expect(user.unlockedAchievements.length, 2);
      expect(user.unlockedAchievements, contains('badge_3'));
      expect(user.unlockedAchievements, contains('badge_4'));
    });

    test('should handle missing unlockedAchievements in JSON gracefully', () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'createdAt': '2023-01-01T00:00:00.000',
        // unlockedAchievements missing
      };

      final user = User.fromJson(json);

      expect(user.unlockedAchievements, isEmpty);
    });
  });
}
