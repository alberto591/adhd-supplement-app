import 'package:neurostack_app/domain/entities/routine_element.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final int xp;
  final int level;
  final bool hasCompletedOnboarding;
  final List<String> goals;
  final String?
      focusStyle; // e.g., 'Combined Type', 'Inattentive', 'Hyperactive'
  final RoutineElement? currentElement;
  final List<String> unlockedAchievements;
  final List<String>
      activeEntitlements; // IDs of purchased entitlements (e.g. 'stack_builder')

  /// Convenience getter that returns displayName
  String? get name => displayName;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.hasCompletedOnboarding = false,
    this.goals = const [],
    this.xp = 0,
    this.level = 1,
    this.focusStyle,
    this.currentElement,
    this.unlockedAchievements = const [],
    this.activeEntitlements = const [],
  });

  static const Object _unset = Object();

  User copyWith({
    String? id,
    String? email,
    Object? displayName = _unset,
    Object? photoUrl = _unset,
    DateTime? createdAt,
    bool? hasCompletedOnboarding,
    List<String>? goals,
    int? xp,
    int? level,
    Object? focusStyle = _unset,
    Object? currentElement = _unset,
    List<String>? unlockedAchievements,
    List<String>? activeEntitlements,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: identical(displayName, _unset)
          ? this.displayName
          : displayName as String?,
      photoUrl:
          identical(photoUrl, _unset) ? this.photoUrl : photoUrl as String?,
      createdAt: createdAt ?? this.createdAt,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      goals: goals ?? this.goals,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      focusStyle: identical(focusStyle, _unset)
          ? this.focusStyle
          : focusStyle as String?,
      currentElement: identical(currentElement, _unset)
          ? this.currentElement
          : currentElement as RoutineElement?,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      activeEntitlements: activeEntitlements ?? this.activeEntitlements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'goals': goals,
      'xp': xp,
      'level': level,
      'focusStyle': focusStyle,
      'currentElement': currentElement?.toJson(),
      'unlockedAchievements': unlockedAchievements,
      'activeEntitlements': activeEntitlements,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      hasCompletedOnboarding: json['hasCompletedOnboarding'] as bool? ?? false,
      goals:
          (json['goals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      focusStyle: json['focusStyle'] as String?,
      currentElement: json['currentElement'] != null
          ? RoutineElement.fromJson(
              json['currentElement'] as Map<String, dynamic>)
          : null,
      unlockedAchievements: (json['unlockedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      activeEntitlements: (json['activeEntitlements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
