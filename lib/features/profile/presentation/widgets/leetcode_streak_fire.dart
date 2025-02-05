
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class LeetCodeStreakFire extends HookWidget {
  final StreakCounter streakCounter;

  const LeetCodeStreakFire({
    super.key,
    required this.streakCounter,
  });

  @override
  Widget build(BuildContext context) {
    final lottieController = useAnimationController();
    final streakCount = streakCounter.streakCount;
    final theme = Theme.of(context);
    final streakColor = streakCounter.currentDayCompleted
        ? theme.primaryColor
        : theme.hintColor;
    return FocusDetector(
      onFocusGained: () {
        if (lottieController.duration != null) {
          lottieController
            ..reset()
            ..forward();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          streakCounter.currentDayCompleted
              ? Lottie.asset(
                  Assets.lotties.flame.path,
                  height: 28,
                  width: 28,
                  repeat: false,
                  controller: lottieController,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    lottieController
                      ..duration = composition.duration
                      ..forward();
                  },
                )
              : Icon(
                  FontAwesomeIcons.fire,
                  color: streakColor,
                  size: 24,
                ),
          const SizedBox(width: 8.0),
          Text(
            '$streakCount',
            style: theme.textTheme.titleLarge?.copyWith(color: streakColor),
          ),
        ],
      ),
    );
  }
}
