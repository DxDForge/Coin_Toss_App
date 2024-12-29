import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/flip_record.dart';

class HistoryService {
  static const String _key = 'flip_history';
  static final HistoryService _instance = HistoryService._internal();

  factory HistoryService() => _instance;
  HistoryService._internal();

  Future<void> addFlip(String result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    history.insert(
        0,
        FlipRecord(
          result: result,
          timestamp: DateTime.now(),
        ));

    // Keep only last 100 flips
    if (history.length > 100) {
      history.removeLast();
    }

    await prefs.setString(
        _key,
        jsonEncode(
          history.map((record) => record.toJson()).toList(),
        ));
  }

  Future<List<FlipRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_key);

    if (historyJson == null) return [];

    List<dynamic> decoded = jsonDecode(historyJson);
    return decoded.map((item) => FlipRecord.fromJson(item)).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final history = await getHistory();

    if (history.isEmpty) {
      return {
        'totalFlips': 0,
        'heads': 0,
        'tails': 0,
        'headsPercentage': 0.0,
        'tailsPercentage': 0.0,
        'longestHeadsStreak': 0,
        'longestTailsStreak': 0,
        'averageFlipsPerDay': 0.0,
        'firstFlip': null,
        'lastFlip': null,
      };
    }

    int heads = 0;
    int currentHeadsStreak = 0;
    int longestHeadsStreak = 0;
    int currentTailsStreak = 0;
    int longestTailsStreak = 0;

    for (var record in history) {
      if (record.result == 'Heads') {
        heads++;
        currentHeadsStreak++;
        currentTailsStreak = 0;
        if (currentHeadsStreak > longestHeadsStreak) {
          longestHeadsStreak = currentHeadsStreak;
        }
      } else {
        currentTailsStreak++;
        currentHeadsStreak = 0;
        if (currentTailsStreak > longestTailsStreak) {
          longestTailsStreak = currentTailsStreak;
        }
      }
    }

    final totalFlips = history.length;
    final tails = totalFlips - heads;

    // Calculate average flips per day
    final firstFlip = history.last.timestamp;
    final lastFlip = history.first.timestamp;
    final daysDifference = lastFlip.difference(firstFlip).inDays + 1;
    final averageFlipsPerDay = totalFlips / daysDifference;

    return {
      'totalFlips': totalFlips,
      'heads': heads,
      'tails': tails,
      'headsPercentage': (heads / totalFlips * 100).toStringAsFixed(1),
      'tailsPercentage': (tails / totalFlips * 100).toStringAsFixed(1),
      'longestHeadsStreak': longestHeadsStreak,
      'longestTailsStreak': longestTailsStreak,
      'averageFlipsPerDay': averageFlipsPerDay.toStringAsFixed(1),
      'firstFlip': firstFlip,
      'lastFlip': lastFlip,
    };
  }
}
