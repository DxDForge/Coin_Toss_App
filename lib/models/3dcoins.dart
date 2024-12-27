import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

enum CoinMaterial {
  gold,
  silver,
  bronze,
  crystal,
  holographic,
  custom,
}

enum CoinRotationStyle {
  standard,
  diagonal,
  verticalWave,
  horizontalWave,
  elliptical,
  zigzag,
  screenOutFlip,
}

enum CoinDesignStyle {
  classic,
  modern,
  futuristic,
  ancient,
  minimalist,
  ornate,
}

enum SpinIntensity {
  slow,
  medium,
  fast,
}

class CoinType {
  final String name;
  final CoinMaterial material;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tailPrimaryColor;
  final Color tailSecondaryColor;
  final String symbol;
  final String countryOfOrigin;
  final List<Color> reflectionGradient;
  final CoinRotationStyle rotationStyle;
  final CoinDesignStyle designStyle;

  CoinType({
    required this.name,
    this.material = CoinMaterial.silver,
    required this.primaryColor,
    required this.secondaryColor,
    Color? tailPrimaryColor,
    Color? tailSecondaryColor,
    required this.symbol,
    this.countryOfOrigin = 'Blockchain Realm',
    this.reflectionGradient = const [
      Color(0xFFE0E0E0),
      Color(0xFFF5F5F5),
      Color(0xFFBDBDBD),
    ],
    this.rotationStyle = CoinRotationStyle.standard,
    this.designStyle = CoinDesignStyle.classic,
  })  : tailPrimaryColor = tailPrimaryColor ?? primaryColor.withOpacity(0.7),
        tailSecondaryColor =
            tailSecondaryColor ?? secondaryColor.withOpacity(0.7);
}

class Coin3D extends StatefulWidget {
  final CoinType coinType;
  final double size;
  final bool isSpinning;
  final SpinIntensity spinIntensity;
  final VoidCallback? onTap;
  final bool showTail;

  const Coin3D({
    Key? key,
    required this.coinType,
    this.size = 250,
    this.isSpinning = false,
    this.spinIntensity = SpinIntensity.medium,
    this.onTap,
    this.showTail = false,
  }) : super(key: key);

  @override
  _Coin3DState createState() => _Coin3DState();
}

class _Coin3DState extends State<Coin3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;
  late Animation<Offset> _trajectoryAnimation;
  bool _isCurrentlySpinning = false; // Add this local state variable

  final math.Random _random = math.Random();
  late double _randomFactor;
  late double _spinSpeed;
  final Offset _startPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _randomFactor = _random.nextDouble() * 0.4 + 0.8;
    _spinSpeed = _getSpinSpeed();

    _controller = AnimationController(
      duration: Duration(milliseconds: _getSpinDuration(widget.spinIntensity)),
      vsync: this,
    );

    _setupAnimations();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isCurrentlySpinning = false;
          _controller.reset(); // Reset the controller when animation completes
        });
      }
    });

    // Initialize the animation if the coin should be spinning
    if (widget.isSpinning) {
      _controller.forward();
    }
  }

  void _setupAnimations() {
    _trajectoryAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(_randomFactor * 0.2, -1.0),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(_randomFactor * 0.2, -1.0),
          end: Offset.zero, // Ensure it returns to starting position
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.8),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        weight: 60,
      ),
    ]).animate(_controller);

    _heightAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.5),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 0.0),
        weight: 60,
      ),
    ]).animate(_controller);

    _blurAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 3.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 3.0, end: 0.0),
        weight: 70,
      ),
    ]).animate(_controller);

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 6 * math.pi * _spinSpeed)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 6 * math.pi * _spinSpeed,
          end: 12 * math.pi * _spinSpeed,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  Animation<Offset> _createTrajectoryAnimation() {
    switch (widget.coinType.rotationStyle) {
      case CoinRotationStyle.screenOutFlip:
        return TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_randomFactor * 0.5, -1.0),
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset(_randomFactor * 0.5, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 60,
          ),
        ]).animate(_controller);

      case CoinRotationStyle.zigzag:
        return TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_randomFactor * 0.3, -0.5),
            ),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset(_randomFactor * 0.3, -0.5),
              end: Offset(-_randomFactor * 0.3, -1.0),
            ),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset(-_randomFactor * 0.3, -1.0),
              end: Offset(_randomFactor * 0.3, -0.5),
            ),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset(_randomFactor * 0.3, -0.5),
              end: Offset.zero,
            ),
            weight: 25,
          ),
        ]).animate(_controller);

      default:
        return TweenSequence<Offset>([
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_randomFactor * 0.2, -1.0),
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<Offset>(
              begin: Offset(_randomFactor * 0.2, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 60,
          ),
        ]).animate(_controller);
    }
  }

  @override
  void didUpdateWidget(Coin3D oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSpinning != oldWidget.isSpinning) {
      setState(() {
        _isCurrentlySpinning = widget.isSpinning;
      });

      if (widget.isSpinning) {
        // Start a new flip animation from the beginning
        _controller.forward(from: 0.0);
      }
      // Remove the else block since we want the animation to complete naturally
    }
  }

  double _getSpinSpeed() {
    switch (widget.spinIntensity) {
      case SpinIntensity.slow:
        return 3.0;
      case SpinIntensity.medium:
        return 5.0;
      case SpinIntensity.fast:
        return 7.0;
    }
  }

  int _getSpinDuration(SpinIntensity intensity) {
    switch (intensity) {
      case SpinIntensity.slow:
        return 2500;
      case SpinIntensity.medium:
        return 1500;
      case SpinIntensity.fast:
        return 1000;
    }
  }

  RadialGradient _createCoinGradient(bool isTail) {
    Color primaryColor = isTail
        ? widget.coinType.tailPrimaryColor
        : widget.coinType.primaryColor;
    Color secondaryColor = isTail
        ? widget.coinType.tailSecondaryColor
        : widget.coinType.secondaryColor;

    return RadialGradient(
      colors: [
        primaryColor,
        secondaryColor,
        isTail ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.6),
      ],
      radius: 1.5,
      center: const Alignment(-0.4, -0.4),
    );
  }

  Widget _buildCoinSurface(bool isTail) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _createCoinGradient(isTail),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Center(
        child: isTail ? _buildReverseSide() : _buildObverseSide(),
      ),
    );
  }

  Widget _buildObverseSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.coinType.symbol,
          style: TextStyle(
            fontSize: widget.size * 0.35,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: const [Colors.white, Colors.yellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, widget.size, widget.size)),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(3, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.coinType.name,
          style: TextStyle(
            fontSize: widget.size * 0.12,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReverseSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'VALUE',
          style: TextStyle(
            fontSize: widget.size * 0.12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(3, 3),
              ),
            ],
          ),
        ),
        Text(
          '1 UNIT',
          style: TextStyle(
            fontSize: widget.size * 0.18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final rotation = widget.isSpinning || _controller.isAnimating
              ? _rotationAnimation.value
              : 0.0;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(
                _trajectoryAnimation.value.dx * widget.size,
                _trajectoryAnimation.value.dy * widget.size * 1.5,
              )
              ..scale(_scaleAnimation.value)
              ..rotateX(_heightAnimation.value * 0.3)
              ..rotateY(rotation),
            child: ImageFiltered(
              imageFilter: (widget.isSpinning || _controller.isAnimating)
                  ? ui.ImageFilter.blur(
                      sigmaX: _blurAnimation.value,
                      sigmaY: _blurAnimation.value,
                    )
                  : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: _buildCoinSurface(widget.showTail),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CoinTypes {
  static List<CoinType> availableCoins = [
    CoinType(
      name: 'Bitcoin',
      primaryColor: const Color(0xFFFFA726),
      secondaryColor: const Color(0xFFFF9800),
      tailPrimaryColor: const Color(0xFF424242),
      tailSecondaryColor: const Color(0xFF212121),
      symbol: '₿',
      countryOfOrigin: 'Crypto Realm',
      rotationStyle: CoinRotationStyle.diagonal,
    ),
    CoinType(
      name: 'Ethereum',
      primaryColor: const Color(0xFF42A5F5),
      secondaryColor: const Color(0xFF2196F3),
      tailPrimaryColor: const Color(0xFFE0E0E0),
      tailSecondaryColor: const Color(0xFFF5F5F5),
      symbol: 'Ξ',
      countryOfOrigin: 'Blockchain Nation',
      rotationStyle: CoinRotationStyle.verticalWave,
    ),
    CoinType(
      name: 'Litecoin',
      primaryColor: const Color(0xFFA0A0A0),
      secondaryColor: const Color(0xFF707070),
      tailPrimaryColor: const Color(0xFFFFFFFF),
      tailSecondaryColor: const Color(0xFFF0F0F0),
      symbol: '��',
      countryOfOrigin: 'Digital Territory',
      rotationStyle: CoinRotationStyle.horizontalWave,
    ),
    CoinType(
      name: 'Cardano',
      primaryColor: const Color(0xFF3C3C3D),
      secondaryColor: const Color(0xFF212121),
      tailPrimaryColor: const Color(0xFFF5F5F5),
      tailSecondaryColor: const Color(0xFFE0E0E0),
      symbol: '₳',
      countryOfOrigin: 'Smart Contract State',
      rotationStyle: CoinRotationStyle.elliptical,
    ),
    CoinType(
      name: 'Ripple',
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFF388E3C),
      tailPrimaryColor: const Color(0xFFFFFFFF),
      tailSecondaryColor: const Color(0xFFF0F0F0),
      symbol: '✕',
      countryOfOrigin: 'Global Transfer Empire',
      rotationStyle: CoinRotationStyle.diagonal,
    ),
    CoinType(
      name: 'Default',
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFF7B1FA2),
      tailPrimaryColor: const Color(0xFFE0E0E0),
      tailSecondaryColor: const Color(0xFFF5F5F5),
      symbol: '◎',
      countryOfOrigin: 'Coin Toss Kingdom',
      rotationStyle: CoinRotationStyle.zigzag,
    ),
  ];

  static CoinType getDefaultCoin() {
    return availableCoins.first;
  }
}
