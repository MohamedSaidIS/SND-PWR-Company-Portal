import 'dart:ui';

import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class AchievementLine extends StatelessWidget {
  final double progress; // 0 → 1
  final double height;
  final EdgeInsets padding;

  const AchievementLine({
    super.key,
    required this.progress,
    this.height = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  });

  LinearGradient progressGradient(double progress) {
    if (progress <= 0.25) {
      return const LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFD32F2F)], // red → orange
      );
    } else if (progress <= 0.5) {
      return const LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFFF7043)], // orange → yellow
      );
    } else if (progress <= 0.75) {
      return const LinearGradient(
        colors: [
          Color(0xFFD32F2F),
          Color(0xFFFF7043),
          Color(0xFFFFEB3B)
        ], // yellow → light green
      );
    } else {
      return const LinearGradient(
        colors: [
          Color(0xFFD32F2F),
          Color(0xFFFF7043),
          Color(0xFFFFEB3B),
          Color(0xFF9CCC65),
          Color(0xFF66BB6A),
          Color(0xFF2E7D32)
        ], // green → dark green
      );
    }
  }
  Color progressColor(double progress) {
    return Color.lerp(
      Colors.red,
      Colors.green,
      progress.clamp(0.0, 1.0),
    )!;
  }
  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final percentText = '${(clamped * 100).round()}%';
    final color = progressColor(clamped);
    final theme = context.theme;
    const double bubbleWidth = 48;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Progress Line", style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        Padding(
          padding: padding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lineWidth = constraints.maxWidth;
              final bubbleLeft = (lineWidth * clamped - bubbleWidth / 2)
                  .clamp(0.0, lineWidth - bubbleWidth);
              return SizedBox(
                height: 65,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Glass background
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: theme.navigationBarTheme.backgroundColor!,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha:0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Progress line
                    Container(
                      height: height,
                      width: lineWidth * clamped,
                      decoration: BoxDecoration(
                        gradient: progressGradient(progress),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // Percentage bubble
                    Positioned(
                       left: bubbleLeft,
                      top: 0,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.95),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha:0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              percentText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // pointer
                          Container(
                            width: 7.5,
                            height: 7.5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.95),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
