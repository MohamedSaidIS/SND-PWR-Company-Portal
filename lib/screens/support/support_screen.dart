import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/export_import.dart';

class SupportScreen extends StatefulWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const SupportScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final ValueNotifier<bool> isPressedNotifier = ValueNotifier(false);
  final ValueNotifier<Map<int, bool>> animatedCardsNotifier =
      ValueNotifier<Map<int, bool>>({});
  late AppLocalizations local;
  late ThemeData theme;
  late ColorScheme colorScheme;
  late List<SupportItem> items;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  void fetchData() {
    final provider = context.read<SPEnsureUserProvider>();
    if (widget.userInfo != null) {
      provider.fetchITSiteEnsureUser("${widget.userInfo!.mail}", context);
      provider.fetchDynamicsSiteEnsureUser("${widget.userInfo!.mail}");
      provider.fetchAlsanidiSiteEnsureUser("${widget.userInfo!.mail}");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     theme = context.theme;
     local = context.local;
     colorScheme = theme.colorScheme;
     items = getSupportItems(local);
  }

  @override
  Widget build(BuildContext context) {
    final directReportList =
        context.watch<DirectReportsProvider>().directReportList;


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(
          title: local.support,
          backBtn: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SideFadeSlideAnimation(
            delay: 0,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return (item.name == "Users New \nRequests" &&
                        directReportList != null &&
                        directReportList.isEmpty)
                    ? const SizedBox.shrink()
                    : InkWell(
                        splashColor: Colors.transparent,
                        onTap: () async {
                          isPressedNotifier.value = true;
                          animatedCardsNotifier.value[index] = true;
                          await Future.delayed(
                              const Duration(milliseconds: 70));
                          animatedCardsNotifier.value[index] = false;

                          navigatedScreen(context, item.name, widget.userInfo, widget.userImage);
                        },
                        child: ValueListenableBuilder<Map<int, bool>>(
                          valueListenable: animatedCardsNotifier,
                          builder: (context, animMap, _) {
                            final isAnimated = animMap[index] ?? false;
                            return SupportCard(
                              title: item.translatedName,
                              image: item.image,
                              isAnimated: isAnimated,
                            );
                          },
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
