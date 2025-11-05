import 'package:carousel_slider/carousel_slider.dart';
import '../../../../utils/export_import.dart';
import 'package:flutter/material.dart';


class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final CarouselSliderController controller = CarouselSliderController();
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isTablet = context.isTablet();
    final isLandScape = context.isLandScape();
    final screenSize = MediaQuery.of(context).size.height;
    final carouselHeight = screenSize * 0.5;
    final items = getSections(local, theme, context, carouselHeight);

    print("CarouselSliderWidgetHeight: ${isLandScape.toString()} $carouselHeight");
    return Column(
      children: [
        SizedBox(
          height:carouselHeight,
          child: CarouselSlider(
            carouselController: controller,
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 3.0,
                enlargeCenterPage: true,
                disableCenter: true,
                animateToClosest: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                }),
            items: items,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(
                  horizontal: isTablet ? 6 : 4,
                  vertical: isTablet ? 8 : 6,
                ),
                height: 8,
                width: current == index
                    ? (isTablet ? 35 : 25)
                    : (isTablet ? 10 : 8),
                decoration: BoxDecoration(
                  color:
                      current == index
                          ? const Color(0xFF1B818E)
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
