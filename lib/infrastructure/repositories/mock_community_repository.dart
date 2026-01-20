import 'package:flutter/material.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/repositories/community_repository.dart';

class MockCommunityRepository implements CommunityRepository {
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      username: 'ADHD Hacker',
      userHandle: '@adhd_hacker',
      postedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      category: 'Morning Routine',
      title:
          'Try setting a \'take supplement\' alarm 10 mins before your actual wake-up.',
      content:
          'This helps the medication start working right as you need to get out of bed. No more morning fog!',
      helpfulCount: 24,
      userColor: Colors.orange,
      userIcon: Icons.person,
    ),
    CommunityPost(
      id: '2',
      username: 'Sleepy Doe',
      userHandle: '@sleepy_doe',
      postedAt: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Sleep Hacks',
      title: 'Magnesium before bed has changed my sleep quality significantly.',
      content:
          'I take Magnesium Glycinate about 30 minutes before lights out. I wake up feeling much more rested.',
      helpfulCount: 156,
      isInsightful: true,
      userColor: Colors.purple,
      userIcon: Icons.bedtime,
    ),
    CommunityPost(
      id: '3',
      username: 'Creative Brain',
      userHandle: '@creative_brain',
      postedAt: DateTime.now().subtract(const Duration(hours: 4)),
      category: 'Supplement Stack',
      title: 'Visual cues are everything! Use a clear pill box.',
      content: '', // Image post implies content might be minimal or alt text
      helpfulCount: 89,
      userColor: Colors.teal,
      userIcon: Icons.palette,
      imageUrl: 'placeholder', // Logic for image card
    ),
  ];

  @override
  Future<List<CommunityPost>> getPosts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (category == null || category == '#All' || category.isEmpty) {
      return _posts;
    }
    // Simple filter mapping: remove # and space matching
    final normalizedFilter = category.replaceAll('#', '').toLowerCase();
    return _posts.where((p) {
      final normalizedCategory = p.category.replaceAll(' ', '').toLowerCase();
      return normalizedCategory.contains(normalizedFilter);
    }).toList();
  }

  @override
  Future<void> toggleHelpful(String postId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isInsightful: !post.isInsightful,
        helpfulCount:
            post.isInsightful ? post.helpfulCount - 1 : post.helpfulCount + 1,
      );
    }
  }
}
