import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neurostack_app/application/view_models/community_view_model.dart';
import 'package:neurostack_app/domain/repositories/community_repository.dart';
import 'package:neurostack_app/domain/entities/community_post.dart';

// Generate mocks
@GenerateMocks([CommunityRepository])
import 'community_view_model_test.mocks.dart';

void main() {
  late MockCommunityRepository mockRepository;
  late CommunityViewModel viewModel;

  setUp(() {
    mockRepository = MockCommunityRepository();
  });

  group('CommunityViewModel', () {
    test('loads posts initially', () async {
      when(mockRepository.getPosts(category: '#All'))
          .thenAnswer((_) async => []);

      viewModel = CommunityViewModel(mockRepository);

      // Wait for constructor calls
      await Future<void>.delayed(Duration.zero);

      expect(viewModel.isLoading, false);
      verify(mockRepository.getPosts(category: '#All')).called(1);
    });

    test('toggleHelpful updates optimistically', () async {
      final post = CommunityPost(
        id: 'p1',
        username: 'User1',
        userHandle: '@user1',
        title: 'Title',
        content: 'Content',
        category: '#All',
        postedAt: DateTime.now(),
        helpfulCount: 10,
        isInsightful: false,
        userColor: const Color(0xFF000000),
        userIconCodePoint: 57352,
      );

      when(mockRepository.getPosts(category: '#All'))
          .thenAnswer((_) async => [post]);
      when(mockRepository.toggleHelpful('p1')).thenAnswer((_) async => {});

      viewModel = CommunityViewModel(mockRepository);
      await Future<void>.delayed(Duration.zero);

      // Act
      await viewModel.toggleHelpful('p1');

      // Assert
      expect(viewModel.posts.first.isInsightful, true);
      expect(viewModel.posts.first.helpfulCount, 11);
      verify(mockRepository.toggleHelpful('p1')).called(1);
    });

    test('toggleHelpful reverts on error', () async {
      final post = CommunityPost(
        id: 'p1',
        username: 'User1',
        userHandle: '@user1',
        title: 'Title',
        content: 'Content',
        category: '#All',
        postedAt: DateTime.now(),
        helpfulCount: 10,
        isInsightful: false,
        userColor: const Color(0xFF000000),
        userIconCodePoint: 57352,
      );

      when(mockRepository.getPosts(category: '#All'))
          .thenAnswer((_) async => [post]);
      when(mockRepository.toggleHelpful('p1')).thenThrow(Exception('Fail'));

      viewModel = CommunityViewModel(mockRepository);
      await Future<void>.delayed(Duration.zero);

      // Act
      await viewModel.toggleHelpful('p1');

      // Assert - should be back to original
      expect(viewModel.posts.first.isInsightful, false);
      expect(viewModel.posts.first.helpfulCount, 10);
    });
  });
}
