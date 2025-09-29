
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:company_portal/models/remote/user_info.dart';
import 'package:company_portal/providers/sp_ensure_user.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_notifier.dart';
import 'complaint_suggestion_form_screen.dart';
import 'history_screen.dart';

class ComplaintSuggestionScreen extends StatefulWidget {
  final UserInfo? userInfo;
  final Uint8List? userImage;

  const ComplaintSuggestionScreen(
      {required this.userInfo, required this.userImage, super.key});

  @override
  State<ComplaintSuggestionScreen> createState() =>
      _ComplaintSuggestionScreenState();
}

class _ComplaintSuggestionScreenState extends State<ComplaintSuggestionScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SPEnsureUserProvider>();

      provider.fetchEnsureUser("${widget.userInfo!.mail}");

    });
  }


  @override
  Widget build(BuildContext context) {
    final ensureUserProvider = context.watch<SPEnsureUserProvider>();
    final ensureUser = ensureUserProvider.ensureUser;

    final theme = context.theme;
    final local = context.local;
    final backIcon = context.backIcon;
    final isTablet = context.isTablet();

    if(!ensureUserProvider.loading && ensureUserProvider.error == null){
      AppNotifier.logWithScreen("ComplaintSuggestion Screen","EnsureUser: ${ensureUser?.id} ${ensureUser?.email}");
    }else if(ensureUserProvider.error != null && ensureUserProvider.error == "401"){
      AppNotifier.loginAgain(context);
    }

    AppNotifier.logWithScreen("ComplaintSuggestion Screen","Image: ${widget.userImage != null}");

    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  backIcon,
                  color: theme.colorScheme.primary,
                )),
            title: Text(local.complaintAndSuggestion,
                style: theme.textTheme.headlineLarge!.copyWith(fontSize: 20)),
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
                    labelColor: theme.colorScheme.background,
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
                            local.complaintSuggestionHeader, isTablet),
                      ),
                      Tab(
                        child: _tabChild(local.history, isTablet),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ComplaintSuggestionFormScreen(
                userName: "${widget.userInfo?.givenName} ${widget.userInfo?.surname}",
                ensureUserId: ensureUser?.id ?? -1,
              ),
              HistoryScreen(userInfo: widget.userInfo, userImage: widget.userImage),
            ],
          ),
        ),
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
