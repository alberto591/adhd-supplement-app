import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neurostack_app/application/view_models/trophy_room_view_model.dart';
import 'package:neurostack_app/domain/repositories/gamification_repository.dart';
import 'package:neurostack_app/domain/entities/gamification.dart';

// Generate mocks
@GenerateMocks([GamificationRepository])
import 'trophy_room_view_model_test.mocks.dart';

void main() {
  late MockGamificationRepository mockRepository;
  late TrophyRoomViewModel viewModel;

  setUp(() {
    mockRepository = MockGamificationRepository();
  });

  group('TrophyRoomViewModel', () {
    test('loads data on initialization', () async {
      final profile = GamificationProfile(
        userId: 'test_user',
        level: 1,
        levelTitle: 'Novice',
        currentXp: 100,
        xpToNextLevel: 200,
        badges: [
          GamificationBadge(
              id: 'b1',
              title: 'First Step',
              subtitle: 'subtitle',
              icon: Icons.star,
              color: Colors.amber,
              isEarned: true,
              earnedDate: DateTime.now())
        ],
      );

      when(mockRepository.getProfile('test_user'))
          .thenAnswer((_) async => profile);

      viewModel = TrophyRoomViewModel(mockRepository, 'test_user');

      // Wait for the constructor's async call to complete
      // Since it's fire-and-forget in constructor, let's wait a tick
      await Future<void>.delayed(Duration.zero);
      // Wait for any async gaps
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.isLoading, false);
      expect(viewModel.profile, isNotNull);
      expect(viewModel.profile!.currentXp, 100);
      expect(viewModel.recentWins.length, 1);
    });

    test('handles error on load', () async {
      when(mockRepository.getProfile('test_user')).thenThrow('Network Error');

      viewModel = TrophyRoomViewModel(mockRepository, 'test_user');

      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(viewModel.isLoading, false);
      expect(viewModel.error, contains('Network Error'));
      expect(viewModel.profile, isNull);
    });
  });
}
