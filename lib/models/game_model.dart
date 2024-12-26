// import 'dart:math';

// class Question {
//   final String question;
//   final List<int> options;
//   final int correctAnswer;
  
//   Question({
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });
// }

// class GameState {
//   int score = 0;
//   int currentLevel = 1;
//   int streak = 0;
//   int timeLeft = 30;
//   bool isGameOver = false;

//   void reset() {
//     score = 0;
//     currentLevel = 1;
//     streak = 0;
//     timeLeft = 30;
//     isGameOver = false;
//   }
// }

// class MathGameModel {
//   final Random _random = Random();

//   Question generateQuestion(int level, double difficultyMultiplier) {
//     final effectiveLevel = (level * difficultyMultiplier).round();
    
//     if (effectiveLevel <= 10) {
//       return _generateSimpleAddition(effectiveLevel);
//     } else if (effectiveLevel <= 20) {
//       return _generateMultiplication(effectiveLevel);
//     } else if (effectiveLevel <= 30) {
//       return _generateMultiStep(effectiveLevel);
//     } else {
//       return _generatePattern(effectiveLevel);
//     }
//   }

//   Question _generateSimpleAddition(int level) {
//     int a = _random.nextInt(10 * level) + 1;
//     int b = _random.nextInt(10 * level) + 1;
//     int answer = a + b;
    
//     return Question(
//       question: "$a + $b = ?",
//       options: _generateOptions(answer, level),
//       correctAnswer: answer
//     );
//   }

//   Question _generateMultiplication(int level) {
//     int a = _random.nextInt(level) + 1;
//     int b = _random.nextInt(level) + 1;
//     int answer = a * b;
    
//     return Question(
//       question: "$a × $b = ?",
//       options: _generateOptions(answer, level),
//       correctAnswer: answer
//     );
//   }

//   Question _generateMultiStep(int level) {
//     int a = _random.nextInt(level) + 1;
//     int b = _random.nextInt(level) + 1;
//     int c = _random.nextInt(level ~/ 2) + 1;
//     int answer = (a * b) + c;
    
//     return Question(
//       question: "($a × $b) + $c = ?",
//       options: _generateOptions(answer, level),
//       correctAnswer: answer
//     );
//   }

//   Question _generatePattern(int level) {
//     int base = _random.nextInt(5) + 2;
//     int start = _random.nextInt(10) + 1;
//     List<int> sequence = List.generate(3, (i) => start * pow(base, i).round());
//     int answer = start * pow(base, 3).round();
    
//     return Question(
//       question: "What comes next? ${sequence.join(', ')}, __",
//       options: _generateOptions(answer, level),
//       correctAnswer: answer
//     );
//   }

//   List<int> _generateOptions(int correct, int level) {
//     Set<int> options = {correct};
//     while (options.length < 4) {
//       int offset = _random.nextInt(10 * level) + 1;
//       if (_random.nextBool()) {
//         options.add(correct + offset);
//       } else {
//         options.add(correct - offset);
//       }
//     }
//     return options.toList()..shuffle();
//   }
// }




import 'dart:math';

enum QuestionDifficulty { easy, medium, hard, expert }

class Question {
  final String question;
  final List<int> options;
  final int correctAnswer;
  final QuestionDifficulty difficulty;
  final int timeEstimate;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.timeEstimate,
  });
}

class GameState {
  int score = 0;
  int currentLevel = 1;
  int streak = 0;
  int timeLeft = 30;
  bool isGameOver = false;
  double multiplier = 1.0;
  int consecutiveCorrect = 0;
  int totalQuestions = 0;
  int correctAnswers = 0;

  void reset() {
    score = 0;
    currentLevel = 1;
    streak = 0;
    timeLeft = 30;
    isGameOver = false;
    multiplier = 1.0;
    consecutiveCorrect = 0;
    totalQuestions = 0;
    correctAnswers = 0;
  }

  double get accuracy => 
    totalQuestions == 0 ? 0.0 : (correctAnswers / totalQuestions) * 100;
}

class MathGameModel {
  final Random _random = Random();
  
  QuestionDifficulty _getDifficultyForLevel(int effectiveLevel) {
    if (effectiveLevel <= 5) return QuestionDifficulty.easy;
    if (effectiveLevel <= 10) return QuestionDifficulty.medium;
    if (effectiveLevel <= 15) return QuestionDifficulty.hard;
    return QuestionDifficulty.expert;
  }

  int _getTimeEstimate(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return 5;
      case QuestionDifficulty.medium:
        return 8;
      case QuestionDifficulty.hard:
        return 12;
      case QuestionDifficulty.expert:
        return 15;
    }
  }

  Question generateQuestion(int level, double difficultyMultiplier) {
    final effectiveLevel = (level * difficultyMultiplier).round();
    final difficulty = _getDifficultyForLevel(effectiveLevel);
    final timeEstimate = _getTimeEstimate(difficulty);

    switch (difficulty) {
      case QuestionDifficulty.easy:
        return _generateSimpleAddition(effectiveLevel, difficulty, timeEstimate);
      case QuestionDifficulty.medium:
        return _generateMultiplication(effectiveLevel, difficulty, timeEstimate);
      case QuestionDifficulty.hard:
        return _generateMultiStep(effectiveLevel, difficulty, timeEstimate);
      case QuestionDifficulty.expert:
        return _generatePattern(effectiveLevel, difficulty, timeEstimate);
    }
  }

  Question _generateSimpleAddition(int level, QuestionDifficulty difficulty, int timeEstimate) {
    int a = _random.nextInt(10 * level) + 1;
    int b = _random.nextInt(10 * level) + 1;
    int answer = a + b;

    if (_random.nextBool() && a > b) {
      answer = a - b;
      return Question(
        question: "$a - $b = ?",
        options: _generateOptions(answer, level, difficulty),
        correctAnswer: answer,
        difficulty: difficulty,
        timeEstimate: timeEstimate,
      );
    }

    return Question(
      question: "$a + $b = ?",
      options: _generateOptions(answer, level, difficulty),
      correctAnswer: answer,
      difficulty: difficulty,
      timeEstimate: timeEstimate,
    );
  }

  Question _generateMultiplication(int level, QuestionDifficulty difficulty, int timeEstimate) {
    int maxNum = (level + 5).clamp(2, 12);
    int a = _random.nextInt(maxNum) + 1;
    int b = _random.nextInt(maxNum) + 1;
    int answer = a * b;

    return Question(
      question: "$a × $b = ?",
      options: _generateOptions(answer, level, difficulty),
      correctAnswer: answer,
      difficulty: difficulty,
      timeEstimate: timeEstimate,
    );
  }

  Question _generateMultiStep(int level, QuestionDifficulty difficulty, int timeEstimate) {
    int maxNum = (level + 3).clamp(2, 10);
    int a = _random.nextInt(maxNum) + 1;
    int b = _random.nextInt(maxNum) + 1;
    int c = _random.nextInt(maxNum ~/ 2) + 1;
    
    bool useMultiplication = _random.nextBool();
    int answer;
    String question;
    
    if (useMultiplication) {
      answer = (a * b) + c;
      question = "($a × $b) + $c = ?";
    } else {
      answer = (a + b) * c;
      question = "($a + $b) × $c = ?";
    }

    return Question(
      question: question,
      options: _generateOptions(answer, level, difficulty),
      correctAnswer: answer,
      difficulty: difficulty,
      timeEstimate: timeEstimate,
    );
  }

  Question _generatePattern(int level, QuestionDifficulty difficulty, int timeEstimate) {
    int patternType = _random.nextInt(3);
    late int answer;
    late String question;
    late List<int> sequence;

    switch (patternType) {
      case 0:
        int base = _random.nextInt(3) + 2;
        int start = _random.nextInt(5) + 1;
        sequence = List.generate(3, (i) => start * pow(base, i).round());
        answer = start * pow(base, 3).round();
        break;
      
      case 1:
        int start = _random.nextInt(10) + 1;
        int diff = _random.nextInt(5) + 2;
        sequence = List.generate(3, (i) => start + (diff * i));
        answer = start + (diff * 3);
        break;
      
      default:
        sequence = [_random.nextInt(5) + 1];
        sequence.add(sequence[0] + _random.nextInt(3) + 1);
        sequence.add(sequence[1] + sequence[0]);
        answer = sequence[2] + sequence[1];
    }

    question = "What comes next? ${sequence.join(', ')}, __";

    return Question(
      question: question,
      options: _generateOptions(answer, level, difficulty),
      correctAnswer: answer,
      difficulty: difficulty,
      timeEstimate: timeEstimate,
    );
  }

  List<int> _generateOptions(int correct, int level, QuestionDifficulty difficulty) {
    Set<int> options = {correct};
    
    int maxOffset = switch (difficulty) {
      QuestionDifficulty.easy => 5,
      QuestionDifficulty.medium => 10,
      QuestionDifficulty.hard => 20,
      QuestionDifficulty.expert => 30,
    };

    while (options.length < 4) {
      int offset = _random.nextInt(maxOffset) + 1;
      if (_random.nextBool()) {
        options.add(correct + offset);
      } else {
        options.add((correct - offset).abs());
      }
    }

    return options.toList()..shuffle(_random);
  }
}
