import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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

  final PageController pageController = PageController();

  @override
  void dispose() {
    currentNotifier.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isLandScape = context.isLandScape();
    final screenSize = MediaQuery.of(context).size.height;
    final carouselHeight = screenSize * (isLandScape ? 0.3 : 0.5);
    //final items = getSections(local, theme, context, carouselHeight);
    print("CarouselSlider Rebuild");


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: pageController,
                itemCount: Section.getSectionsData(local, context).length,
                itemBuilder: (context, index) {
                  return SectionWidget(
                      section: Section.getSectionsData(local, context)[index],
                      theme: theme,
                      isEnglish: context.isEnglish(),
                      carouselHeight: carouselHeight);
                }
            ),
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: Section
                .getSectionsData(local, context)
                .length,
            effect: const WormEffect(
              dotWidth: 10.0, dotHeight: 10.0,
              activeDotColor: Color(0xFF1B818E),
            ),
          )

        ],
      ),
    );

    // return Column(
    //   children: [
    //     SizedBox(
    //       height: carouselHeight,
    //       child: RepaintBoundary(
    //         child: CarouselSlider(
    //           carouselController: controller,
    //           options: CarouselOptions(
    //               autoPlay: true,
    //               aspectRatio: 3.0,
    //               enlargeCenterPage: true,
    //               disableCenter: true,
    //               // animateToClosest: true,
    //               onPageChanged: (index, reason) {
    //                 currentNotifier.value = index;
    //               }),
    //           items: List.generate(5, (index) {
    //             final sections = Section.getSectionsData(local, context);
    //             final s = sections[index];
    //             return SectionWidget(
    //               key: ValueKey(s.title ?? s.description),
    //               section: s,
    //               theme: theme,
    //               isEnglish: context.isEnglish(),
    //               carouselHeight: carouselHeight,
    //             );
    //           }),
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 8.0),
    //       child: ValueListenableBuilder<int>(
    //           valueListenable: currentNotifier,
    //           builder: (context, current, _) {
    //             return Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: List.generate(5, (index) {
    //                 final isActive = current == index;
    //                 return Container(
    //                   margin: const EdgeInsets.symmetric(horizontal: 4),
    //                   height: 8,
    //                   width:
    //                       isActive ? (isTablet ? 35 : 25) : (isTablet ? 10 : 8),
    //                   decoration: BoxDecoration(
    //                     color: current == index
    //                         ? const Color(0xFF1B818E)
    //                         : Colors.grey,
    //                     borderRadius: BorderRadius.circular(4),
    //                   ),
    //                 );
    //               }),
    //             );
    //           }),
    //     ),
    //   ],
    // );
  }
}
