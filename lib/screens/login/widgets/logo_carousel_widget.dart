import 'package:flutter/material.dart';
import 'carousel_slider.dart';

class LogoAndCarouselWidget extends StatelessWidget {
  final String assetPath;

  const LogoAndCarouselWidget({
    super.key,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandScape = orientation == Orientation.landscape;
        final screenSize = MediaQuery.of(context).size;

        final double logoHeight = screenSize.height * (isLandScape ? 0.16 : 0.15);
        final double padding = screenSize.width * (isLandScape ? 0.01 : 0.13);
        final double verticalPadding = isLandScape? 5 : 10;


        print("📏 CarouselSlider width: ${screenSize.width} | padding: $padding | isLandScape: $isLandScape");

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: padding, left: padding, bottom: verticalPadding),
              child: Image.asset(
                assetPath,
                height: logoHeight,
                fit: BoxFit.contain,
              ),
            ),
            const Expanded(child: CarouselSliderWidget()),
          ],
        );
      },
    );
  }
}