import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../data/login_data.dart';

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
    final items = getItems(local, theme, context);
    final isTablet = context.isTablet();

    return Column(
      children: [
        CarouselSlider(
          carouselController: controller,
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.55,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(
                horizontal: isTablet ? 6 : 4,
                vertical: isTablet ? 14 : 12,
              ),
              height: 8,
              width: current == index
                  ? (isTablet ? 35 : 25)
                  : (isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color:
                    current == index ? const Color(0xFF1B818E) : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
