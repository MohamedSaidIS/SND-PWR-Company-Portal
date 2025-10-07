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
    this.heightFactor = 0.2,
    this.topFactor = 0.03,
    this.horizontalPaddingFactor = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double logoHeight = screenSize.height * heightFactor;
    final double horizontalPadding = screenSize.width * horizontalPaddingFactor;


    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        child: Image.asset(
          assetPath,
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ),
      const Expanded(child: CarouselSliderWidget()),
    ]
    );
  }
}