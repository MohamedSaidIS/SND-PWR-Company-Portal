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
  final ValueNotifier<int> currentNotifier = ValueNotifier(0);

  @override
  void dispose() {
    currentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isTablet = context.isTablet();
    final isLandScape = context.isLandScape();
    final screenSize = MediaQuery.of(context).size.height;
    final carouselHeight = screenSize * (isLandScape ? 0.3 : 0.5);
    //final items = getSections(local, theme, context, carouselHeight);
    print("CarouselSlider Rebuild");

    return Column(
      children: [
        SizedBox(
          height: carouselHeight,
          child: RepaintBoundary(
            child: CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 3.0,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  // animateToClosest: true,
                  onPageChanged: (index, reason) {
                    currentNotifier.value = index;
                  }),
              items: List.generate(5, (index) {
                final sections = getSectionsData(local, context);
                final s = sections[index];
                return SectionWidget(
                  key: ValueKey(s.title ?? s.description),
                  section: s,
                  theme: theme,
                  isEnglish: context.isEnglish(),
                  carouselHeight: carouselHeight,
                );
              }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ValueListenableBuilder<int>(
              valueListenable: currentNotifier,
              builder: (context, current, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final isActive = current == index;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width:
                          isActive ? (isTablet ? 35 : 25) : (isTablet ? 10 : 8),
                      decoration: BoxDecoration(
                        color: current == index
                            ? const Color(0xFF1B818E)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                );
              }),
        ),
      ],
    );
  }
}
