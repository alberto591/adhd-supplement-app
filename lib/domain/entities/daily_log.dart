class DailyLog {
  final String id;
  final String userId;
  final DateTime date;
  final List<LogEntry> entries;
  final Map<String, int>? symptomRatings; // symptom name -> rating (1-5)
  final String? notes;
  final DateTime createdAt;

  const DailyLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.entries,
    this.symptomRatings,
    this.notes,
    required this.createdAt,
  });

  DailyLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    List<LogEntry>? entries,
    Map<String, int>? symptomRatings,
    String? notes,
    DateTime? createdAt,
  }) {
    return DailyLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      entries: entries ?? this.entries,
      symptomRatings: symptomRatings ?? this.symptomRatings,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'entries': entries.map((e) => e.toJson()).toList(),
      'symptomRatings': symptomRatings,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      symptomRatings: (json['symptomRatings'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as int),
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class LogEntry {
  final String supplementId;
  final DateTime takenAt;
  final bool taken;
  final String? skippedReason;

  const LogEntry({
    required this.supplementId,
    required this.takenAt,
    required this.taken,
    this.skippedReason,
  });

  static const Object _unset = Object();

  LogEntry copyWith({
    String? supplementId,
    DateTime? takenAt,
    bool? taken,
    Object? skippedReason = _unset,
  }) {
    return LogEntry(
      supplementId: supplementId ?? this.supplementId,
      takenAt: takenAt ?? this.takenAt,
      taken: taken ?? this.taken,
      skippedReason: identical(skippedReason, _unset)
          ? this.skippedReason
          : skippedReason as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplementId': supplementId,
      'takenAt': takenAt.toIso8601String(),
      'taken': taken,
      'skippedReason': skippedReason,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      supplementId: json['supplementId'] as String,
      takenAt: DateTime.parse(json['takenAt'] as String),
      taken: json['taken'] as bool,
      skippedReason: json['skippedReason'] as String?,
    );
  }
}
