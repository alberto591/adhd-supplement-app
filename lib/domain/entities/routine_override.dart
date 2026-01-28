class RoutineOverride {
  final String id;
  final String userId;
  final String compatibilityId;
  final DateTime timestamp;
  final String? userReason;
  final bool
      isAcknowledged; // Whether user explicitly checked "I understand the risks"

  const RoutineOverride({
    required this.id,
    required this.userId,
    required this.compatibilityId,
    required this.timestamp,
    this.userReason,
    this.isAcknowledged = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'compatibilityId': compatibilityId,
      'timestamp': timestamp.toIso8601String(),
      'userReason': userReason,
      'isAcknowledged': isAcknowledged,
    };
  }

  factory RoutineOverride.fromJson(Map<String, dynamic> json) {
    return RoutineOverride(
      id: json['id'] as String,
      userId: json['userId'] as String,
      compatibilityId: json['compatibilityId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userReason: json['userReason'] as String?,
      isAcknowledged: json['isAcknowledged'] as bool? ?? false,
    );
  }
}
