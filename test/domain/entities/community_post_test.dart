import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_supplement_app/domain/entities/community_post.dart';

void main() {
  group('CommunityPost', () {
    test('getIcon returns correct IconData for valid code points', () {
      expect(CommunityPost.getIcon(58655), Icons.bedtime);
      expect(CommunityPost.getIcon(58498), Icons.palette);
      expect(CommunityPost.getIcon(58611), Icons.bolt);
      expect(CommunityPost.getIcon(60599), Icons.psychology);
      expect(CommunityPost.getIcon(57352), Icons.person);
    });

    test('getIcon returns default person icon for unknown code points', () {
      expect(CommunityPost.getIcon(0), Icons.person);
      expect(CommunityPost.getIcon(99999), Icons.person);
    });
  });
}
