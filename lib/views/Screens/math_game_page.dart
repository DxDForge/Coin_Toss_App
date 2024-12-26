// // import 'package:coin_toss/controllers/math_game_controller.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'dart:async';

// // class MathGameView extends StatefulWidget {
// //   @override
// //   _MathGameViewState createState() => _MathGameViewState();
// // }

// // class _MathGameViewState extends State<MathGameView> with TickerProviderStateMixin {
// //   late Timer _timer;
// //   late AnimationController _timerController;
// //   late AudioPlayer _audioPlayer;
  
// //   @override
// //   void initState() {
// //     super.initState();
// //     _audioPlayer = AudioPlayer();
// //     _timerController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 30),
// //     );
// //     _startTimer();
// //   }

// //   void _startTimer() {
// //     _timerController.forward(from: 0.0);
// //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       context.read<MathGameController>().updateTimer();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _timer.cancel();
// //     _timerController.dispose();
// //     _audioPlayer.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _playSound(bool correct) async {
// //     final String soundFile = correct ? 'correct.mp3' : 'incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(soundFile));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<MathGameController>(
// //       builder: (context, controller, child) {
// //         return Scaffold(
// //           body: SafeArea(
// //             child: Stack(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.all(16.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// //                     children: [
// //                       _buildHeader(controller),
// //                       const SizedBox(height: 16),
// //                       _buildProgressBar(controller),
// //                       const SizedBox(height: 16),
// //                       AnimatedSwitcher(
// //                         duration: const Duration(milliseconds: 300),
// //                         child: _buildQuestion(controller),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       Expanded(
// //                         child: _buildAnswerOptions(controller),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (controller.isGameOver)
// //                   Positioned.fill(
// //                     child: _buildGameOver(controller),
// //                   ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildHeader(MathGameController controller) {
// //     return SizedBox(
// //       height: 80,
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('Score: ${controller.score}',
// //                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //               Text('High Score: ${controller.highScore}',
// //                   style: const TextStyle(fontSize: 16)),
// //             ],
// //           ),
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('Level: ${controller.currentLevel}',
// //                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //               Text('Streak: ${controller.streak}',
// //                   style: const TextStyle(fontSize: 16)),
// //             ],
// //           ),
// //           SizedBox(
// //             width: 100,
// //             child: AnimatedBuilder(
// //               animation: _timerController,
// //               builder: (context, child) {
// //                 return Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     Text('Time: ${controller.timeLeft}',
// //                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 4),
// //                     LinearProgressIndicator(
// //                       value: controller.timeLeft / 30,
// //                       valueColor: AlwaysStoppedAnimation<Color>(
// //                         controller.timeLeft > 10 ? Colors.green : Colors.red,
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildProgressBar(MathGameController controller) {
// //     return SizedBox(
// //       height: 10,
// //       child: LinearProgressIndicator(
// //         value: controller.progressToNextLevel,
// //         valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
// //         backgroundColor: Colors.blue.withOpacity(0.2),
// //       ),
// //     );
// //   }

// //   Widget _buildQuestion(MathGameController controller) {
// //     return Container(
// //       key: ValueKey(controller.question.question),
// //       padding: const EdgeInsets.symmetric(vertical: 32.0),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(
// //             'Difficulty: ${controller.currentDifficulty.toStringAsFixed(1)}',
// //             style: const TextStyle(fontSize: 16, color: Colors.grey),
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             controller.question.question,
// //             style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildAnswerOptions(MathGameController controller) {
// //     return GridView.count(
// //       crossAxisCount: 2,
// //       mainAxisSpacing: 10,
// //       crossAxisSpacing: 10,
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       children: controller.question.options.map((option) {
// //         return AnimatedContainer(
// //           duration: const Duration(milliseconds: 300),
// //           child: ElevatedButton(
// //             onPressed: () {
// //               final bool correct = option == controller.question.correctAnswer;
// //               _playSound(correct);
// //               controller.checkAnswer(option);
// //             },
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.all(20),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(15),
// //               ),
// //             ),
// //             child: Text(
// //               option.toString(),
// //               style: const TextStyle(fontSize: 24),
// //             ),
// //           ),
// //         );
// //       }).toList(),
// //     );
// //   }

// //   Widget _buildGameOver(MathGameController controller) {
// //     return Container(
// //       color: Colors.black54,
// //       padding: const EdgeInsets.all(16.0),
// //       child: Center(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Text('Game Over!',
// //                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
// //             const SizedBox(height: 16),
// //             Text('Final Score: ${controller.score}',
// //                 style: const TextStyle(fontSize: 24, color: Colors.white)),
// //             const SizedBox(height: 8),
// //             Text('High Score: ${controller.highScore}',
// //                 style: const TextStyle(fontSize: 20, color: Colors.white)),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: controller.resetGame,
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
// //               ),
// //               child: const Text('Play Again'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:coin_toss/controllers/math_game_controller.dart';
import 'package:coin_toss/models/game_model.dart';

class MathGameView extends StatefulWidget {
  const MathGameView({Key? key}) : super(key: key);

  @override
  _MathGameViewState createState() => _MathGameViewState();
}

class _MathGameViewState extends State<MathGameView> with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _timerController;
  late AnimationController _streakController;
  late AnimationController _messageController;
  late AudioPlayer _audioPlayer;
  
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _streakController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerController.dispose();
    _streakController.dispose();
    _messageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.forward(from: 0.0);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      context.read<MathGameController>().updateTimer();
    });
  }

  Future<void> _playSound(bool correct) async {
    final String soundFile = correct ? 'correct.mp3' : 'incorrect.mp3';
    await _audioPlayer.play(AssetSource(soundFile));
  }

  Color _getDifficultyColor(QuestionDifficulty difficulty) {
    switch (difficulty) {
      case QuestionDifficulty.easy:
        return Colors.green;
      case QuestionDifficulty.medium:
        return Colors.blue;
      case QuestionDifficulty.hard:
        return Colors.orange;
      case QuestionDifficulty.expert:
        return Colors.red;
    }
  }

  Widget _buildHeader(MathGameController controller) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: ${controller.score}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('High Score: ${controller.highScore}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.local_fire_department,
                      color: controller.streak > 0 ? Colors.orange : Colors.grey),
                  Text(' ${controller.streak}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: controller.streak > 0 ? Colors.orange : Colors.grey,
                      )),
                ],
              ),
              Text('Level ${controller.currentLevel}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${controller.timeLeft}s',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: controller.timeLeft / 30,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    controller.isInBufferPhase 
                        ? Colors.orange 
                        : (controller.timeLeft > 10 ? Colors.green : Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalMessage(MathGameController controller) {
    final message = controller.motivationalMessage;
    if (message == null) return const SizedBox(height: 8);
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActiveChallenge(MathGameController controller) {
    final challenge = controller.activeChallenge;
    if (challenge == null) return const SizedBox(height: 8);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              challenge.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(MathGameController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: controller.progressToNextLevel,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getDifficultyColor(controller.questionDifficulty),
            ),
            backgroundColor: Colors.grey.withOpacity(0.2),
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Level: ${(controller.progressToNextLevel * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'Accuracy: ${controller.accuracy.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(MathGameController controller) {
    return Container(
      key: ValueKey(controller.currentQuestion.question),
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(controller.questionDifficulty),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.questionDifficulty.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            controller.currentQuestion.question,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(MathGameController controller) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: controller.currentQuestion.options.map((option) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed: () {
              final bool correct = option == controller.currentQuestion.correctAnswer;
              _playSound(correct);
              if (correct) {
                _streakController.forward(from: 0.0);
              }
              controller.checkAnswer(option);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              option.toString(),
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGameOver(MathGameController controller) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Game Over!',
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              )
            ),
            const SizedBox(height: 24),
            Text(
              'Final Score: ${controller.score}',
              style: const TextStyle(fontSize: 32, color: Colors.white)
            ),
            const SizedBox(height: 12),
            if (controller.score >= controller.highScore && controller.highScore > 0)
              const Text(
                'New High Score! 🎉',
                style: TextStyle(fontSize: 24, color: Colors.yellow)
              ),
            const SizedBox(height: 16),
            Text(
              'High Score: ${controller.highScore}',
              style: const TextStyle(fontSize: 24, color: Colors.white70)
            ),
            const SizedBox(height: 8),
            Text(
              'Accuracy: ${controller.accuracy.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20, color: Colors.white70)
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.resetGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MathGameController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(controller),
                    _buildActiveChallenge(controller),
                    _buildMotivationalMessage(controller),
                    const SizedBox(height: 8),
                    _buildProgressBar(controller),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildQuestion(controller),
                    ),
                    Expanded(
                      child: _buildAnswerOptions(controller),
                    ),
                  ],
                ),
                if (controller.isGameOver)
                  Positioned.fill(
                    child: _buildGameOver(controller),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


//-----------------------------------------------------------------------
