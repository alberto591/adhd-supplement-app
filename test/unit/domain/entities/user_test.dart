import 'package:flutter_test/flutter_test.dart';
import 'package:neurostack_app/domain/entities/user.dart';
import 'package:neurostack_app/domain/entities/routine_element.dart';

void main() {
  group('User Entity', () {
    final baseUser = User(
      id: '123',
      email: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
    );

    test('should copyWith level and xp correctly', () {
      final updatedUser = baseUser.copyWith(
        level: 10,
        xp: 2500,
      );

      expect(updatedUser.level, 10);
      expect(updatedUser.xp, 2500);
      expect(updatedUser.email, baseUser.email);
    });

    test('should copyWith unlockedAchievements correctly', () {
      final updatedUser = baseUser.copyWith(
        unlockedAchievements: ['badge_1', 'badge_2'],
      );

      expect(updatedUser.unlockedAchievements.length, 2);
      expect(updatedUser.unlockedAchievements, contains('badge_1'));
      expect(updatedUser.unlockedAchievements, contains('badge_2'));
    });

    test('should copyWith currentRoutineElement correctly', () {
      final med = RoutineElement.fromName('Adderall XR', dosage: 20);
      final updatedUser = baseUser.copyWith(currentElement: med);

      expect(updatedUser.currentElement, isNotNull);
      expect(updatedUser.currentElement?.name, 'Adderall XR');
      expect(updatedUser.currentElement?.dosage, 20);
    });

    test('should serialize unlockedAchievements and medication to JSON', () {
      final med = RoutineElement.fromName('Vyvanse', dosage: 30);
      final user = baseUser.copyWith(
        unlockedAchievements: ['badge_1'],
        level: 5,
        xp: 500,
        currentElement: med,
      );

      final json = user.toJson();

      expect(json['unlockedAchievements'], isA<List<String>>());
      expect(json['unlockedAchievements'], contains('badge_1'));
      expect(json['level'], 5);
      expect(json['xp'], 500);
      expect(json['currentElement'], isNotNull);
      expect(json['currentElement']['name'], 'Vyvanse');
    });

    test('should deserialize unlockedAchievements and medication from JSON',
        () {
      final json = {
        'id': '123',
        'email': 'test@example.com',
        'createdAt': '2023-01-01T00:00:00.000',
        'level': 2,
        'xp': 100,
        'unlockedAchievements': ['badge_3', 'badge_4'],
        'currentElement': {
          'id': 'm1',
          'name': 'Concerta',
          'type': 'typeA',
          'dosage': 18.0,
        },
      };

      final user = User.fromJson(json);

      expect(user.level, 2);
      expect(user.unlockedAchievements.length, 2);
      expect(user.unlockedAchievements, contains('badge_3'));
      expect(user.currentElement, isNotNull);
      expect(user.currentElement?.name, 'Concerta');
      expect(user.currentElement?.type, ElementCategory.typeA);
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
