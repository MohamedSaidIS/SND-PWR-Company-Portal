import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import 'carousel_slider.dart';

class LogoAndCarouselWidget extends StatelessWidget {
  final String assetPath;
  final double heightFactor; // percentage of screen width
  final double topFactor; // percentage of screen height
  final double horizontalPaddingFactor; // percentage of screen width

  const LogoAndCarouselWidget({
    super.key,
    required this.assetPath,
    this.heightFactor = 0.2, // 20% of screen width
    this.topFactor = 0.03, // 3% of screen height
    this.horizontalPaddingFactor = 0.12, // 5% of screen width
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double logoHeight = screenSize.height * heightFactor;
    final double topPadding = screenSize.height * topFactor;
    final double horizontalPadding = screenSize.width * horizontalPaddingFactor;
    final isTablet = context.isTablet();

    // Calculate space for logo
    final double gapBelowLogo = isTablet ? 20.0 : 0.0;
    final double carouselTopPadding =
        topPadding + logoHeight + gapBelowLogo;

    return Stack(
      children: [Positioned(
        top: topPadding,
        left: horizontalPadding,
        right: horizontalPadding,
        child: Image.asset(
          assetPath,
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ),
        Padding(
          padding: EdgeInsets.only(top: carouselTopPadding),
          child: const CarouselSliderWidget(),
        ),
      ]
    );
  }
}