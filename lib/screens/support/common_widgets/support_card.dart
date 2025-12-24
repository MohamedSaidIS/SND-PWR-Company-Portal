import 'package:flutter/material.dart';
import '../../../utils/export_import.dart';

class SupportCard extends StatelessWidget {
  final String title;
  final String image;
  final bool isAnimated;
  const SupportCard({super.key, required this.title, required this.image, required this.isAnimated});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ScaleAnimation(
      isAnimated: isAnimated,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface.withValues(alpha: 0.5),
                ),
                child: Center(
                  child: RepaintBoundary(
                    child: Image.asset(
                      image,
                      cacheWidth: 55,
                      cacheHeight: 55,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
