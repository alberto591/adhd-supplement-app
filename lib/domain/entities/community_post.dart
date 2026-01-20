import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String username;
  final String userHandle; // e.g. @adhd_hacker
  final DateTime postedAt;
  final String category; // e.g. Morning Routine
  final String title;
  final String content;
  final int helpfulCount;
  final bool isInsightful; // If current user marked it
  final Color userColor;
  final IconData userIcon;
  final String? imageUrl; // Optional image

  const CommunityPost({
    required this.id,
    required this.username,
    required this.userHandle,
    required this.postedAt,
    required this.category,
    required this.title,
    required this.content,
    required this.helpfulCount,
    this.isInsightful = false,
    required this.userColor,
    required this.userIcon,
    this.imageUrl,
  });

  CommunityPost copyWith({
    String? id,
    String? username,
    String? userHandle,
    DateTime? postedAt,
    String? category,
    String? title,
    String? content,
    int? helpfulCount,
    bool? isInsightful,
    Color? userColor,
    IconData? userIcon,
    String? imageUrl,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      username: username ?? this.username,
      userHandle: userHandle ?? this.userHandle,
      postedAt: postedAt ?? this.postedAt,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isInsightful: isInsightful ?? this.isInsightful,
      userColor: userColor ?? this.userColor,
      userIcon: userIcon ?? this.userIcon,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
