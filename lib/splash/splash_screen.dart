import 'dart:math';


import 'package:flutter/material.dart';

import '../Auth/firebase/auth_wrapper.dart';



class DairySplashScreen extends StatefulWidget {
  const DairySplashScreen({super.key});

  @override
  State<DairySplashScreen> createState() => _DairySplashScreenState();
}

class _DairySplashScreenState extends State<DairySplashScreen>
    with TickerProviderStateMixin {
  late AnimationController innerRotation;
  late AnimationController outerRotation;
  late AnimationController scaleController;

  @override
  void initState() {
    super.initState();

    // Inner (slower rotation)
    innerRotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    // Outer (faster rotation)
    outerRotation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    // Scaling logo
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // Navigation after splash
    Future.delayed(const Duration(seconds: 1), () async {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });


  }

  @override
  void dispose() {
    innerRotation.dispose();
    outerRotation.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7CB342), // medium green
              Color(0xFFC8E6C9), // light mint green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glowing circle behind logo
              AnimatedBuilder(
                animation: scaleController,
                builder: (context, child) {
                  return Container(
                    width: 165 + (scaleController.value * 30),
                    height: 165 + (scaleController.value * 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // App logo + title
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: scaleController,
                  curve: Curves.elasticOut,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_drink_rounded,
                      size: 90,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 9),
                    Text(
                      "DairyApp",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Font",
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: const [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Inner circle text
              RotationTransition(
                turns: innerRotation,
                child: CustomPaint(
                  painter: CircleTextPainter(
                    text: " Fresh Milk · Daily Products · Quality Guaranteed · ",
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Font1",
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    radius: 150,
                  ),
                ),
              ),

              // Outer circle text
              RotationTransition(
                turns: outerRotation,
                child: CustomPaint(
                  painter: CircleTextPainter(
                    text: " Natural · Organic · Farm Fresh · Pure Goodness · ",
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Font2",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    radius: 210,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double radius;

  CircleTextPainter({
    required this.text,
    required this.textStyle,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double angle = -pi / 2;
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final tp = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final x = radius * cos(angle) + size.width / 2 - tp.width / 2;
      final y = radius * sin(angle) + size.height / 2 - tp.height / 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + pi / 2);
      tp.paint(canvas, Offset.zero);
      canvas.restore();

      angle += (2 * pi) / text.length;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
