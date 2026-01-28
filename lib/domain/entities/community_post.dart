import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String username;
  final String userHandle; // e.g. @focus_hacker
  final DateTime postedAt;
  final String category; // e.g. Morning Routine
  final String title;
  final String content;
  final int helpfulCount;
  final bool isInsightful; // If current user marked it
  final Color userColor;
  final int userIconCodePoint;
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
    required this.userIconCodePoint,
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
    int? userIconCodePoint,
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
      userIconCodePoint: userIconCodePoint ?? this.userIconCodePoint,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userHandle': userHandle,
      'postedAt': postedAt.toIso8601String(),
      'category': category,
      'title': title,
      'content': content,
      'helpfulCount': helpfulCount,
      'isInsightful': isInsightful,
      'userColor': userColor.toARGB32(),
      'userIcon': userIconCodePoint,
      'imageUrl': imageUrl,
    };
  }

  /// Static helper to get IconData from a code point.
  /// Using explicit constant mapping ensures icon tree-shaking works.
  static IconData getIcon(int codePoint) {
    switch (codePoint) {
      case 58655:
        return Icons.bedtime;
      case 58498:
        return Icons.palette;
      case 58611:
        return Icons.bolt;
      case 60599:
        return Icons.psychology;
      case 57352:
      default:
        return Icons.person;
    }
  }

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      username: json['username'] as String,
      userHandle: json['userHandle'] as String,
      postedAt: DateTime.parse(json['postedAt'] as String),
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      isInsightful: json['isInsightful'] as bool? ?? false,
      userColor: Color(json['userColor'] as int? ?? 0xFF000000),
      userIconCodePoint: json['userIcon'] as int? ?? 57352,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
