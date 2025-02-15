import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  @override
  LoadingDotsState createState() => LoadingDotsState();
}

class LoadingDotsState extends State<LoadingDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      )..repeat(reverse: true);
    });

    // Stagger the animations
    Future.delayed(Duration.zero, () {
      _controllers[1].forward(from: 0.3);
      _controllers[2].forward(from: 0.6);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(controller);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(
                  0.4 + (_animations[index].value * 0.6),
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}