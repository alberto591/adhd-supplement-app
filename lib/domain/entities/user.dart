class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final bool hasCompletedOnboarding;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.hasCompletedOnboarding = false,
  });

  static const Object _unset = Object();

  User copyWith({
    String? id,
    String? email,
    Object? displayName = _unset,
    Object? photoUrl = _unset,
    DateTime? createdAt,
    bool? hasCompletedOnboarding,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName:
          identical(displayName, _unset) ? this.displayName : displayName as String?,
      photoUrl: identical(photoUrl, _unset) ? this.photoUrl : photoUrl as String?,
      createdAt: createdAt ?? this.createdAt,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
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
    );
  }
}
