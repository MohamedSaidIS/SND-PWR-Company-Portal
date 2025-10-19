import 'package:auto_size_text/auto_size_text.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class CommonSupportAppbar extends StatelessWidget {
  final String title;
  final String tabTitle;
  final List<Widget> tabBarChildren;

  const CommonSupportAppbar(
      {required this.title,
      required this.tabTitle,
      required this.tabBarChildren,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final backIcon = context.backIcon;
    final isTablet = context.isTablet();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              backIcon,
              color: theme.colorScheme.primary,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.headlineLarge!.copyWith(fontSize: 20),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xfcecd4c7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: theme.colorScheme.surface,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  unselectedLabelColor: theme.colorScheme.secondary,
                  labelStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      child: _tabChild(
                        tabTitle,
                        isTablet,
                      ),
                    ),
                    Tab(
                      child: _tabChild(
                        local.history,
                        isTablet,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(children: tabBarChildren),
      ),
    );
  }
}

Widget _tabChild(String text, bool isTablet) {
  return AutoSizeText(
    text,
    style: TextStyle(fontSize: isTablet ? 18 : 14),
    maxLines: 1,
    minFontSize: 10,
    overflow: TextOverflow.ellipsis,
  );
}
