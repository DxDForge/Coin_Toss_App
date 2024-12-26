// import 'package:coin_toss/models/game_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MathGameController with ChangeNotifier {
//   final MathGameModel _model = MathGameModel();
//   final GameState _state = GameState();
//   late Question currentQuestion;
//   int _highScore = 0;
//   double _difficultyMultiplier = 1.0;
  
//   MathGameController() {
//     _loadHighScore();
//     _generateNewQuestion();
//   }

//   Future<void> _loadHighScore() async {
//     final prefs = await SharedPreferences.getInstance();
//     _highScore = prefs.getInt('highScore') ?? 0;
//     notifyListeners();
//   }

//   Future<void> _saveHighScore() async {
//     if (score > _highScore) {
//       _highScore = score;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt('highScore', _highScore);
//     }
//   }

//   void _generateNewQuestion() {
//     currentQuestion = _model.generateQuestion(_state.currentLevel, _difficultyMultiplier);
//     notifyListeners();
//   }

//   void checkAnswer(int selectedAnswer) {
//     if (_state.isGameOver) return;
    
//     final bool isCorrect = selectedAnswer == currentQuestion.correctAnswer;
//     final int timeTaken = 30 - _state.timeLeft;
    
//     if (isCorrect) {
//       _state.score += (10 * _state.currentLevel * (1 + _state.streak * 0.1)).round();
//       _state.streak++;
      
//       if (_state.streak > 0 && _state.streak % 3 == 0) {
//         _state.currentLevel++;
//         _adjustDifficulty(true, timeTaken);
//       }
//     } else {
//       _state.streak = 0;
//       _adjustDifficulty(false, timeTaken);
//     }
    
//     _generateNewQuestion();
//   }

//   void _adjustDifficulty(bool wasCorrect, int timeTaken) {
//     double timeBonus = timeTaken < 5 ? 0.2 : timeTaken < 10 ? 0.1 : 0.05;
    
//     if (wasCorrect) {
//       _difficultyMultiplier += timeBonus;
//     } else {
//       _difficultyMultiplier -= 0.1;
//     }
    
//     _difficultyMultiplier = _difficultyMultiplier.clamp(0.5, 2.0);
//   }

//   void updateTimer() {
//     if (_state.timeLeft > 0) {
//       _state.timeLeft--;
//       if (_state.timeLeft == 0) {
//         _state.isGameOver = true;
//         _saveHighScore();
//       }
//       notifyListeners();
//     }
//   }

//   void resetGame() {
//     _state.reset();
//     _difficultyMultiplier = 1.0;
//     _generateNewQuestion();
//   }

//   // Getters
//   int get score => _state.score;
//   int get currentLevel => _state.currentLevel;
//   int get streak => _state.streak;
//   int get timeLeft => _state.timeLeft;
//   bool get isGameOver => _state.isGameOver;
//   Question get question => currentQuestion;
//   int get highScore => _highScore;
//   double get currentDifficulty => _state.currentLevel * _difficultyMultiplier;
//   double get progressToNextLevel => (_state.streak % 3) / 3;
// }

// import 'dart:math';
// import 'package:coin_toss/models/game_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Challenge {
//   final String description;
//   final int target;
//   final String type;
//   bool isCompleted;

//   Challenge({
//     required this.description,
//     required this.target,
//     required this.type,
//     this.isCompleted = false,
//   });
// }

// class GameMetrics {
//   int correctAnswers = 0;
//   int totalAnswers = 0;
//   double averageResponseTime = 0.0;
//   List<int> recentTimes = [];
  
//   double get accuracy => totalAnswers == 0 ? 0.0 : correctAnswers / totalAnswers;
  
//   void addResponseTime(int time) {
//     recentTimes.add(time);
//     if (recentTimes.length > 5) recentTimes.removeAt(0);
//     averageResponseTime = recentTimes.isEmpty ? 0.0 : 
//       recentTimes.reduce((a, b) => a + b) / recentTimes.length;
//   }

//   void reset() {
//     correctAnswers = 0;
//     totalAnswers = 0;
//     averageResponseTime = 0.0;
//     recentTimes.clear();
//   }
// }

// class MathGameController with ChangeNotifier {
//   final MathGameModel _model = MathGameModel();
//   final GameState _state = GameState();
//   final GameMetrics _metrics = GameMetrics();
//   late Question _currentQuestion;
//   int _highScore = 0;
//   Challenge? _activeChallenge;
  
//   static const int _baseScore = 10;
//   static const double _streakMultiplierIncrement = 0.1;
//   static const int _streakThreshold = 3;
//   static const int _timeBufferThreshold = 10;
  
//   final List<String> _streakMessages = [
//     "You're on fire! 🔥",
//     "Unstoppable! ⚡",
//     "Math genius! 🧠",
//     "Amazing streak! 🌟"
//   ];
  
//   String? _currentMessage;
//   bool _isInBufferPhase = false;
  
//   MathGameController() {
//     _loadHighScore();
//     _generateNewQuestion();
//     _generateNewChallenge();
//   }

//   void resetGame() {
//     _state.reset();
//     _metrics.reset();
//     _isInBufferPhase = false;
//     _currentMessage = null;
//     _generateNewQuestion();
//     _generateNewChallenge();
//     notifyListeners();
//   }

//   void _generateNewQuestion() {
//     _currentQuestion = _model.generateQuestion(
//       _state.currentLevel,
//       _state.multiplier
//     );
//   }

//   void _generateNewChallenge() {
//     if (_activeChallenge?.isCompleted ?? true) {
//       final challenges = [
//         Challenge(
//           type: 'streak',
//           target: _state.currentLevel + 2,
//           description: 'Get a streak of ${_state.currentLevel + 2} correct answers'
//         ),
//         Challenge(
//           type: 'speed',
//           target: 5,
//           description: 'Answer 3 questions in under 5 seconds each'
//         ),
//         Challenge(
//           type: 'accuracy',
//           target: 90,
//           description: 'Maintain 90% accuracy for the next 5 questions'
//         )
//       ];
      
//       _activeChallenge = challenges[Random().nextInt(challenges.length)];
//       notifyListeners();
//     }
//   }

//   void _updateChallenge(bool wasCorrect, int timeTaken) {
//     if (_activeChallenge == null) return;
    
//     switch (_activeChallenge!.type) {
//       case 'streak':
//         if (_state.streak >= _activeChallenge!.target) {
//           _completeChallenge();
//         }
//         break;
//       case 'speed':
//         if (timeTaken <= _activeChallenge!.target) {
//           _completeChallenge();
//         }
//         break;
//       case 'accuracy':
//         if (_metrics.accuracy >= _activeChallenge!.target / 100) {
//           _completeChallenge();
//         }
//         break;
//     }
//   }

//   void _completeChallenge() {
//     if (_activeChallenge != null && !_activeChallenge!.isCompleted) {
//       _activeChallenge!.isCompleted = true;
//       _state.timeLeft += 10;
//       _currentMessage = "Challenge completed! +10s ⭐";
//       notifyListeners();
//     }
//   }

//   void checkAnswer(int selectedAnswer) {
//     if (_state.isGameOver) return;
    
//     final bool isCorrect = selectedAnswer == _currentQuestion.correctAnswer;
//     final int timeTaken = 30 - _state.timeLeft;
    
//     _metrics.totalAnswers++;
//     if (isCorrect) _metrics.correctAnswers++;
//     _metrics.addResponseTime(timeTaken);
    
//     if (isCorrect) {
//       _handleCorrectAnswer(timeTaken);
//     } else {
//       _handleIncorrectAnswer();
//     }
    
//     _updateChallenge(isCorrect, timeTaken);
//     _generateNewQuestion();
//     _generateNewChallenge();
//     notifyListeners();
//   }

//   void _handleCorrectAnswer(int timeTaken) {
//     double timeBonus = _calculateTimeBonus(timeTaken);
    
//     _state.streak++;
//     _state.consecutiveCorrect++;
    
//     if (_state.streak > 0 && _state.streak % 5 == 0) {
//       _state.timeLeft = min(_state.timeLeft + 5, 30);
//       _currentMessage = "${_streakMessages[Random().nextInt(_streakMessages.length)]} +5s";
//     }
    
//     int basePoints = _baseScore * _state.currentLevel;
//     double streakMultiplier = 1 + (_state.streak * _streakMultiplierIncrement);
//     int points = (basePoints * streakMultiplier * (1 + timeBonus)).round();
    
//     _state.score += points;
    
//     if (_state.consecutiveCorrect >= _streakThreshold) {
//       _state.currentLevel++;
//       _state.consecutiveCorrect = 0;
//       _adjustDifficulty(true, timeTaken);
//       _currentMessage = "Level Up! 🎯";
//     }
//   }

//   void _handleIncorrectAnswer() {
//     _state.streak = 0;
//     _state.consecutiveCorrect = 0;
//     _state.multiplier = max(1.0, _state.multiplier - 0.1);
    
//     if (_state.timeLeft <= _timeBufferThreshold && !_isInBufferPhase) {
//       _isInBufferPhase = true;
//       _state.timeLeft += 5;
//       _currentMessage = "Buffer time activated! +5s ⚡";
//     }
//   }

//   void _adjustDifficulty(bool wasCorrect, int timeTaken) {
//     if (wasCorrect && timeTaken < _currentQuestion.timeEstimate) {
//       _state.multiplier = min(2.0, _state.multiplier + 0.1);
//     } else if (!wasCorrect) {
//       _state.multiplier = max(1.0, _state.multiplier - 0.1);
//     }
//   }

//   double _calculateTimeBonus(int timeTaken) {
//     if (timeTaken <= _currentQuestion.timeEstimate ~/ 2) {
//       return 0.5;
//     } else if (timeTaken <= _currentQuestion.timeEstimate) {
//       return 0.2;
//     }
//     return 0.0;
//   }
// // File: lib/controllers/math_game_controller.dart (continued)

//   Future<void> _loadHighScore() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       _highScore = prefs.getInt('highScore') ?? 0;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error loading high score: $e');
//       _highScore = 0;
//     }
//   }

//   Future<void> _saveHighScore() async {
//     if (_state.score > _highScore) {
//       _highScore = _state.score;
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt('highScore', _highScore);
//         notifyListeners();
//       } catch (e) {
//         debugPrint('Error saving high score: $e');
//       }
//     }
//   }

//   void updateTimer() {
//     if (_state.timeLeft > 0) {
//       _state.timeLeft--;
      
//       if (_currentMessage != null && _state.timeLeft % 2 == 0) {
//         _currentMessage = null;
//       }
      
//       if (_state.timeLeft == 0 && !_tryActivateBufferPhase()) {
//         _state.isGameOver = true;
//         _saveHighScore();
//       }
//       notifyListeners();
//     }
//   }

//   bool _tryActivateBufferPhase() {
//     if (!_isInBufferPhase && _metrics.accuracy >= 0.7) {
//       _isInBufferPhase = true;
//       _state.timeLeft += 5;
//       _currentMessage = "Last chance bonus! +5s ⚡";
//       return true;
//     }
//     return false;
//   }

//   // Getters
//   String? get motivationalMessage => _currentMessage;
//   Challenge? get activeChallenge => _activeChallenge;
//   double get accuracy => _metrics.accuracy * 100;
//   double get averageResponseTime => _metrics.averageResponseTime;
//   bool get isInBufferPhase => _isInBufferPhase;
//   int get score => _state.score;
//   int get currentLevel => _state.currentLevel;
//   int get streak => _state.streak;
//   int get timeLeft => _state.timeLeft;
//   bool get isGameOver => _state.isGameOver;
//   Question get currentQuestion => _currentQuestion;
//   int get highScore => _highScore;
//   double get currentDifficulty => _state.currentLevel * _state.multiplier;
//   double get progressToNextLevel => _state.consecutiveCorrect / _streakThreshold;
//   QuestionDifficulty get questionDifficulty => _currentQuestion.difficulty;
// }






//----------------------------------------------



import 'dart:convert';
import 'dart:math';
import 'package:coin_toss/models/game_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Challenge {
  final String description;
  final int target;
  final String type;
  bool isCompleted;

  Challenge({
    required this.description,
    required this.target,
    required this.type,
    this.isCompleted = false,
  });
}

class GameMetrics {
  int correctAnswers = 0;
  int totalAnswers = 0;
  double averageResponseTime = 0.0;
  List<int> recentTimes = [];
  
  double get accuracy => totalAnswers == 0 ? 0.0 : correctAnswers / totalAnswers;
  
  void addResponseTime(int time) {
    recentTimes.add(time);
    if (recentTimes.length > 5) recentTimes.removeAt(0);
    averageResponseTime = recentTimes.isEmpty ? 0.0 : 
      recentTimes.reduce((a, b) => a + b) / recentTimes.length;
  }

  void reset() {
    correctAnswers = 0;
    totalAnswers = 0;
    averageResponseTime = 0.0;
    recentTimes.clear();
  }
}

class Champion {
  final String name;
  final int score;
  final DateTime achievedAt;

  Champion({
    required this.name,
    required this.score,
    required this.achievedAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'score': score,
    'achievedAt': achievedAt.toIso8601String(),
  };

  factory Champion.fromJson(Map<String, dynamic> json) => Champion(
    name: json['name'] as String,
    score: json['score'] as int,
    achievedAt: DateTime.parse(json['achievedAt'] as String),
  );
}

class MathGameController with ChangeNotifier {
  final MathGameModel _model = MathGameModel();
  final GameState _state = GameState();
  final GameMetrics _metrics = GameMetrics();
  late Question _currentQuestion;
  Champion? _currentChampion;
  Champion? _previousChampion;
  bool _isNewHighScore = false;
  Challenge? _activeChallenge;
  
  static const int _baseScore = 10;
  static const double _streakMultiplierIncrement = 0.1;
  static const int _streakThreshold = 3;
  static const int _timeBufferThreshold = 10;
  
  final List<String> _streakMessages = [
    "You're on fire! 🔥",
    "Unstoppable! ⚡",
    "Math genius! 🧠",
    "Amazing streak! 🌟"
  ];
  
  String? _currentMessage;
  bool _isInBufferPhase = false;
  
  MathGameController() {
    _loadHighScore();
    _generateNewQuestion();
    _generateNewChallenge();
  }

  void resetGame() {
    _state.reset();
    _metrics.reset();
    _isInBufferPhase = false;
    _currentMessage = null;
    _isNewHighScore = false;
    _generateNewQuestion();
    _generateNewChallenge();
    notifyListeners();
  }

  Future<void> setChampionName(String name) async {
    if (_isNewHighScore && _state.score > (_currentChampion?.score ?? 0)) {
      _previousChampion = _currentChampion;
      _currentChampion = Champion(
        name: name.trim().isEmpty ? 'Anonymous' : name.trim(),
        score: _state.score,
        achievedAt: DateTime.now(),
      );
      await _saveChampionData();
      notifyListeners();
    }
  }

  Future<void> _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final championJson = prefs.getString('champion');
      if (championJson != null) {
        final Map<String, dynamic> championData = 
          Map<String, dynamic>.from(await json.decode(championJson));
        _currentChampion = Champion.fromJson(championData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading champion data: $e');
      _currentChampion = null;
    }
  }

  Future<void> _saveChampionData() async {
    if (_currentChampion != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final championJson = json.encode(_currentChampion!.toJson());
        await prefs.setString('champion', championJson);
      } catch (e) {
        debugPrint('Error saving champion data: $e');
      }
    }
  }

  void _generateNewQuestion() {
    _currentQuestion = _model.generateQuestion(
      _state.currentLevel,
      _state.multiplier
    );
  }

  void _generateNewChallenge() {
    if (_activeChallenge?.isCompleted ?? true) {
      final challenges = [
        Challenge(
          type: 'streak',
          target: _state.currentLevel + 2,
          description: 'Get a streak of ${_state.currentLevel + 2} correct answers'
        ),
        Challenge(
          type: 'speed',
          target: 5,
          description: 'Answer 3 questions in under 5 seconds each'
        ),
        Challenge(
          type: 'accuracy',
          target: 90,
          description: 'Maintain 90% accuracy for the next 5 questions'
        )
      ];
      
      _activeChallenge = challenges[Random().nextInt(challenges.length)];
      notifyListeners();
    }
  }

  void _updateChallenge(bool wasCorrect, int timeTaken) {
    if (_activeChallenge == null) return;
    
    switch (_activeChallenge!.type) {
      case 'streak':
        if (_state.streak >= _activeChallenge!.target) {
          _completeChallenge();
        }
        break;
      case 'speed':
        if (timeTaken <= _activeChallenge!.target) {
          _completeChallenge();
        }
        break;
      case 'accuracy':
        if (_metrics.accuracy >= _activeChallenge!.target / 100) {
          _completeChallenge();
        }
        break;
    }
  }

  void _completeChallenge() {
    if (_activeChallenge != null && !_activeChallenge!.isCompleted) {
      _activeChallenge!.isCompleted = true;
      _state.timeLeft += 10;
      _currentMessage = "Challenge completed! +10s ⭐";
      notifyListeners();
    }
  }

  void checkAnswer(int selectedAnswer) {
    if (_state.isGameOver) return;
    
    final bool isCorrect = selectedAnswer == _currentQuestion.correctAnswer;
    final int timeTaken = 30 - _state.timeLeft;
    
    _metrics.totalAnswers++;
    if (isCorrect) _metrics.correctAnswers++;
    _metrics.addResponseTime(timeTaken);
    
    if (isCorrect) {
      _handleCorrectAnswer(timeTaken);
    } else {
      _handleIncorrectAnswer();
    }
    
    _updateChallenge(isCorrect, timeTaken);
    _generateNewQuestion();
    _generateNewChallenge();
    
    // Check for new high score
    if (_state.score > (_currentChampion?.score ?? 0)) {
      _isNewHighScore = true;
      if (!_state.isGameOver) {
        _currentMessage = "New high score! Keep going! 🏆";
      }
    }
    
    notifyListeners();
  }

  void _handleCorrectAnswer(int timeTaken) {
    double timeBonus = _calculateTimeBonus(timeTaken);
    
    _state.streak++;
    _state.consecutiveCorrect++;
    
    if (_state.streak > 0 && _state.streak % 5 == 0) {
      _state.timeLeft = min(_state.timeLeft + 5, 30);
      _currentMessage = "${_streakMessages[Random().nextInt(_streakMessages.length)]} +5s";
    }
    
    int basePoints = _baseScore * _state.currentLevel;
    double streakMultiplier = 1 + (_state.streak * _streakMultiplierIncrement);
    int points = (basePoints * streakMultiplier * (1 + timeBonus)).round();
    
    _state.score += points;
    
    if (_state.consecutiveCorrect >= _streakThreshold) {
      _state.currentLevel++;
      _state.consecutiveCorrect = 0;
      _adjustDifficulty(true, timeTaken);
      _currentMessage = "Level Up! 🎯";
    }
  }

  void _handleIncorrectAnswer() {
    _state.streak = 0;
    _state.consecutiveCorrect = 0;
    _state.multiplier = max(1.0, _state.multiplier - 0.1);
    
    if (_state.timeLeft <= _timeBufferThreshold && !_isInBufferPhase) {
      _isInBufferPhase = true;
      _state.timeLeft += 5;
      _currentMessage = "Buffer time activated! +5s ⚡";
    }
  }

  void _adjustDifficulty(bool wasCorrect, int timeTaken) {
    if (wasCorrect && timeTaken < _currentQuestion.timeEstimate) {
      _state.multiplier = min(2.0, _state.multiplier + 0.1);
    } else if (!wasCorrect) {
      _state.multiplier = max(1.0, _state.multiplier - 0.1);
    }
  }

  double _calculateTimeBonus(int timeTaken) {
    if (timeTaken <= _currentQuestion.timeEstimate ~/ 2) {
      return 0.5;
    } else if (timeTaken <= _currentQuestion.timeEstimate) {
      return 0.2;
    }
    return 0.0;
  }

  void updateTimer() {
    if (_state.timeLeft > 0) {
      _state.timeLeft--;
      
      if (_currentMessage != null && _state.timeLeft % 2 == 0) {
        _currentMessage = null;
      }
      
      if (_state.timeLeft == 0 && !_tryActivateBufferPhase()) {
        _state.isGameOver = true;
        if (_isNewHighScore) {
          _currentMessage = "🎉 New High Score! Enter your name to claim your crown! 👑";
        }
      }
      notifyListeners();
    }
  }

  bool _tryActivateBufferPhase() {
    if (!_isInBufferPhase && _metrics.accuracy >= 0.7) {
      _isInBufferPhase = true;
      _state.timeLeft += 5;
      _currentMessage = "Last chance bonus! +5s ⚡";
      return true;
    }
    return false;
  }

  // Getters
  String? get motivationalMessage => _currentMessage;
  Challenge? get activeChallenge => _activeChallenge;
  double get accuracy => _metrics.accuracy * 100;
  double get averageResponseTime => _metrics.averageResponseTime;
  bool get isInBufferPhase => _isInBufferPhase;
  int get score => _state.score;
  int get currentLevel => _state.currentLevel;
  int get streak => _state.streak;
  int get timeLeft => _state.timeLeft;
  bool get isGameOver => _state.isGameOver;
  Question get currentQuestion => _currentQuestion;
  int get highScore => _currentChampion?.score ?? 0;
  String get championName => _currentChampion?.name ?? 'No Champion Yet';
  bool get isNewHighScore => _isNewHighScore;
  Champion? get currentChampion => _currentChampion;
  Champion? get previousChampion => _previousChampion;
  double get currentDifficulty => _state.currentLevel * _state.multiplier;
  double get progressToNextLevel => _state.consecutiveCorrect / _streakThreshold;
  QuestionDifficulty get questionDifficulty => _currentQuestion.difficulty;
}

