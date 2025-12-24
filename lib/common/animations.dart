import 'package:flutter/material.dart';

class UpFadeSlideAnimation extends StatelessWidget {
  final int delay;
  final Widget child;

  const UpFadeSlideAnimation(
      {super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)), child: child),
      ),
    );
  }
}

class SideFadeSlideAnimation extends StatelessWidget {
  final int delay;
  final Widget child;

  const SideFadeSlideAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(20 * (1 - value), 0), child: child),
      ),
    );
  }
}

class CardSlideAnimation extends StatelessWidget {
  final int index;
  final Widget child;

  const CardSlideAnimation(
      {super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 500),
      curve: Curves.easeOut,
      builder: (_, value, __) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset((1 - value) * 50, 0),
            child: child,
          ),
        );
      },
    );
  }
}

class ScaleAnimation extends StatelessWidget {
  final bool isAnimated;
  final Widget child;

  const ScaleAnimation(
      {super.key, required this.isAnimated, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isAnimated ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isAnimated ? 0.75 : 1.0,
        duration: const Duration(milliseconds: 10),
        child: child,
      ),
    );
  }
}
