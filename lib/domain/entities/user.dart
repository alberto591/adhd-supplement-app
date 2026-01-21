class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final int xp;
  final int level;
  final bool hasCompletedOnboarding;
  final String? adhdType; // e.g., 'Combined Type', 'Inattentive', 'Hyperactive'
  final List<String> unlockedAchievements; // IDs of unlocked achievements

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.hasCompletedOnboarding = false,
    this.xp = 0,
    this.level = 1,
    this.adhdType,
    this.unlockedAchievements = const [],
  });

  static const Object _unset = Object();

  User copyWith({
    String? id,
    String? email,
    Object? displayName = _unset,
    Object? photoUrl = _unset,
    DateTime? createdAt,
    bool? hasCompletedOnboarding,
    int? xp,
    int? level,
    Object? adhdType = _unset,
    List<String>? unlockedAchievements,
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
      xp: xp ?? this.xp,
      level: level ?? this.level,
      adhdType:
          identical(adhdType, _unset) ? this.adhdType : adhdType as String?,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
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
      'xp': xp,
      'level': level,
      'adhdType': adhdType,
      'unlockedAchievements': unlockedAchievements,
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
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      adhdType: json['adhdType'] as String?,
      unlockedAchievements: (json['unlockedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
