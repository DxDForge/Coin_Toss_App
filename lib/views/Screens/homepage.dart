import 'dart:math';

import 'package:coin_toss/controllers/coin_flip_controller.dart';
import 'package:coin_toss/models/3dcoins.dart';
import 'package:coin_toss/models/Scenario.dart';
import 'package:coin_toss/views/Screens/math_game_page.dart';
import 'package:coin_toss/views/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// Import necessary pages and dependencies
import 'coin_selection_page.dart';
import 'settings_page.dart';
import 'package:coin_toss/services/history_service.dart';

class CoinFlipHomePage extends StatefulWidget {
  const CoinFlipHomePage({Key? key}) : super(key: key);

  @override
  _CoinFlipHomePageState createState() => _CoinFlipHomePageState();
}

class _CoinFlipHomePageState extends State<CoinFlipHomePage>
    with TickerProviderStateMixin {
  // Add this method inside the _CoinFlipHomePageState class
  String _getRandomInterpretation(String result) {
    // Get the appropriate list of interpretations based on the result
    final interpretations = _resultInterpretations[result] ?? [];

    // If no interpretations available, return a default message
    if (interpretations.isEmpty) {
      return 'The coin has spoken!';
    }

    // Return a random interpretation from the list
    return interpretations[Random().nextInt(interpretations.length)];
  }

  // Controller and State Management
  late CoinFlipController _controller;
  late ConfettiController _confettiController;
  late AnimationController _flipAnimationController;
  late AnimationController _resultAnimationController;

  // State Variables
  CoinType _currentCoin = CoinTypes.getDefaultCoin();
  Color _currentBackground = const Color(0xFF6A11CB);
  String _currentPrompt = 'Your Fate Awaits!';
  bool _isFlipping = false;
  bool _showResultOverlay = false;
  String _currentResult = '';
  String _resultInterpretation = '';
  late Animation<double> _resultAnimation;

  // Psychological Engagement Mechanisms
  final List<String> _dramaticPhrases = [
    'Destiny unfolds...',
    'The universe decides...',
    'Fate is about to speak...',
    'Cosmic winds are turning...',
    'Secrets are revealing...',
  ];

  final Map<String, List<String>> _resultInterpretations = {
    'Heads': [
      'Leadership is calling',
      'Embrace your inner visionary',
      'Your intuition is spot on',
      'Opportunities are aligning',
      'Confidence is your superpower'
    ],
    'Tails': [
      'Reflect and recalibrate',
      'Hidden wisdom awaits',
      'Patience is your strength',
      'Explore alternative paths',
      'Inner peace is your guide'
    ]
  };

  // Update the initState to properly initialize animations
  @override
  void initState() {
    super.initState();

    _controller = CoinFlipController(
      currentCoin: _currentCoin,
    );

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    // Configure flip animation with proper completion behavior
    _flipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Result animation setup
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _resultAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.elasticOut,
    ));

    // Load selected coin
    _controller.loadSelectedCoin().then((_) {
      if (mounted) {
        setState(() {
          _currentCoin = _controller.currentCoin;
        });
      }
    });
  }

  // Update the _revealResult method to handle state properly
  void _revealResult(String result) {
    if (!mounted) return;

    // Add this line to record the flip
    HistoryService().addFlip(result);

    setState(() {
      _showResultOverlay = true;
      _currentResult = result;
      _resultInterpretation = _getRandomInterpretation(result);
      _currentBackground =
          result == 'Heads' ? const Color(0xFF4A90E2) : const Color(0xFFE74C3C);
    });

    _resultAnimationController.forward(from: 0.0);

    // Auto-dismiss result
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _showResultOverlay = false;
      });
      _resultAnimationController.reset();
    });
  }
  // Coin Flip Method
// In _CoinFlipHomePageState class

  void _flipCoin() {
    if (_isFlipping) return;

    setState(() {
      _isFlipping = true;
      _showResultOverlay = false;
      _currentPrompt = 'Flipping...';
    });

    // Reset animations
    _flipAnimationController.reset();
    _resultAnimationController.reset();

    // Start the flip animation
    _flipAnimationController.forward();

    // Calculate total animation duration
    final animationDuration = _flipAnimationController.duration!.inMilliseconds;

    // Get flip result
    final flipResult = _controller.flipCoin();

    // Schedule the result reveal after animation completes
    Future.delayed(Duration(milliseconds: animationDuration), () {
      if (!mounted) return;

      setState(() {
        _currentBackground = flipResult.newBackground;
        _currentPrompt = flipResult.newPrompt;
        _isFlipping = false; // Reset flipping state
        _flipAnimationController
            .reset(); // Reset the animation immediately after flip completes
      });

      // Show result with a slight delay
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        _revealResult(flipResult.result);
        _confettiController.play();
      });
    });
  }

  // Navigation Methods
  void _navigateToCoinSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinSelectionPage(
          onCoinSelected: (CoinType selectedCoin) {
            _controller.saveCoinSelection(selectedCoin);
            setState(() {
              _currentCoin = selectedCoin;
            });
          },
        ),
      ),
    );
  }

  // Information Dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Coin Toss Mechanics',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎲 Each flip is a 50/50 chance\n'
                '🌈 Dynamic backgrounds reflect your luck\n'
                '🪙 Collect and customize your coins\n'
                '📊 Track your flip history and streaks',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Tip: The more you flip, the more exciting it gets!',
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Got it!',
                style: GoogleFonts.poppins(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Build Drawer (Keeping the previous implementation)
  Drawer _buildCustomDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF16213E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Coin Toss App',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Navigate and Explore',
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items (keeping previous implementation)
          _buildDrawerNavItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerNavItem(
            icon: Icons.select_all,
            title: 'Custom Coin',
            onTap: () => _navigateToCoinSelection(),
          ),
          _buildDrawerNavItem(
            icon: Icons.games,
            title: 'Coin Toss Game',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MathGameView()),
            ),
          ),
          _buildDrawerNavItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Navigation Item Helper
  Widget _buildDrawerNavItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Coin Toss',
              textStyle: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 1000),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _currentBackground,
                  _currentBackground.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Dynamic Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        _isFlipping ? 'Spinning...' : _currentPrompt,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Flips: ${_controller.gameState.totalCoins} | Current Streak: ${_controller.gameState.currentStreak}',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Coin Flip Section
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _flipCoin,
                          child: Coin3D(
                            coinType: _currentCoin,
                            size: 250,
                            isSpinning: _isFlipping,
                            spinIntensity: SpinIntensity.slow,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _isFlipping
                              ? ''
                              : _controller.gameState.currentResult,
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _navigateToCoinSelection,
                        icon: const Icon(Icons.monetization_on,
                            color: Colors.white),
                        label: Text(
                          'Select Coin',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
// In the existing CoinFlipHomePage, modify the Scenarios button onPressed method:

                      ElevatedButton.icon(
                        onPressed: () async {
                          // Get the list of scenarios
                          final scenarios = ScenarioList.getScenarios();

                          // Show a scenario selection dialog with improved design
                          final selectedScenario = await showDialog<Scenario>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Choose a Scenario',
                                    style: GoogleFonts.orbitron(
                                        fontWeight: FontWeight.bold)),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: scenarios
                                        .map((scenario) => Card(
                                              elevation: 4,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              color: scenario.color
                                                  .withOpacity(0.1),
                                              child: ListTile(
                                                leading: Icon(scenario.icon,
                                                    color: scenario.color),
                                                title: Text(scenario.title,
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: scenario.color)),
                                                subtitle: Text(
                                                    scenario.description,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 12)),
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pop(scenario),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          );

                          // If a scenario is selected, proceed to its details
                          if (selectedScenario != null) {
                            final scenarioResult = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScenarioDetailPage(
                                    scenario: selectedScenario),
                              ),
                            );

                            // Check if a scenario was selected and details were returned
                            if (scenarioResult != null) {
                              // Destructure the returned scenario details
                              final scenario =
                                  scenarioResult['scenario'] as Scenario;
                              final player1 =
                                  scenarioResult['player1'] as String;
                              final player1Side =
                                  scenarioResult['player1Side'] as String;
                              final player2 =
                                  scenarioResult['player2'] as String;
                              final player2Side =
                                  scenarioResult['player2Side'] as String;

                              // Set the scenario in the controller
                              _controller.setScenario(scenario, player1,
                                  player1Side, player2, player2Side);

                              // Add a slight delay before performing the coin flip
                              await Future.delayed(const Duration(seconds: 2));

                              // Perform the scenario coin flip
                              setState(() {
                                _isFlipping = true;
                                _showResultOverlay = false;
                                _currentPrompt = 'Flipping...';
                              });

                              // Reset animations
                              _flipAnimationController.reset();
                              _resultAnimationController.reset();

                              // Start the flip animation
                              _flipAnimationController.forward();

                              // Calculate total animation duration
                              final animationDuration = _flipAnimationController
                                  .duration!.inMilliseconds;

                              // Get flip result
                              final flipResult =
                                  _controller.flipCoin(isScenarioMode: true);

                              // Schedule the result reveal after animation completes
                              Future.delayed(
                                  Duration(milliseconds: animationDuration),
                                  () {
                                if (!mounted) return;

                                setState(() {
                                  _currentBackground = flipResult.newBackground;
                                  _currentPrompt = flipResult.newPrompt;
                                  _isFlipping = false;
                                  _flipAnimationController.reset();
                                });

                                // Show result with a slight delay
                                Future.delayed(
                                    const Duration(milliseconds: 600), () {
                                  if (!mounted) return;
                                  _revealResult(flipResult.result);
                                  _confettiController.play();
                                });
                              });
                            }
                          }
                        },
                        icon: const Icon(Icons.sports_esports,
                            color: Colors.white),
                        label: Text('Scenarios',
                            style: GoogleFonts.poppins(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Result Overlay
          if (_showResultOverlay)
            Positioned.fill(
              child: ScaleTransition(
                scale: _resultAnimation,
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Dramatic Prelude
                        Text(
                          'The Moment of Truth',
                          style: GoogleFonts.orbitron(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Animated Result
                        AnimatedTextKit(
                          animatedTexts: [
                            ScaleAnimatedText(
                              _currentResult,
                              textStyle: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(5.0, 5.0),
                                  ),
                                ],
                              ),
                              scalingFactor: 0.5,
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 500),
                        ),

                        // Inspirational Interpretation
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            _resultInterpretation,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Confetti Overlay
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _flipAnimationController.dispose();
    _resultAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
}
