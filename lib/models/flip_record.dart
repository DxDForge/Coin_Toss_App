class FlipRecord {
  final String result;
  final DateTime timestamp;

  FlipRecord({
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'result': result,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FlipRecord.fromJson(Map<String, dynamic> json) => FlipRecord(
        result: json['result'],
        timestamp: DateTime.parse(json['timestamp']),
      );
} 