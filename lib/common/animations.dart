import 'package:flutter/material.dart';

class UpFadeSlideAnimation extends StatelessWidget {
  final int delay;
  final Widget child;
  const UpFadeSlideAnimation({super.key, required this.delay, required this.child});

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

class ScaleAnimation extends StatelessWidget{
  final bool isAnimated;
  final Widget child;
  const ScaleAnimation({super.key, required this.isAnimated, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isAnimated ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: isAnimated ? 0.75 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: child,
      ),
    );
  }

}
