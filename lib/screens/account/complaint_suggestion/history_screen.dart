
import 'dart:typed_data';

import 'package:company_portal/screens/account/complaint_suggestion/widgets/status_badge.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/complaint_suggestion_provider.dart';
import '../../../utils/app_notifier.dart';
import 'history_item_details.dart';

class HistoryScreen extends StatefulWidget {
  final dynamic userInfo;
  final Uint8List? userImage;

  const HistoryScreen({required this.userInfo, required this.userImage, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintSuggestionProvider =
      context.read<ComplaintSuggestionProvider>();

      complaintSuggestionProvider.fetchSuggestionsAndComplaints(widget.userInfo.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final complaintSuggestionProvider =
    context.watch<ComplaintSuggestionProvider>();
    final complaintSuggestionList =
    complaintSuggestionProvider.complaintSuggestionList!.toList();

    if(complaintSuggestionProvider.error != null && complaintSuggestionProvider.error =="401"){
      AppNotifier.loginAgain(context);
    }

    final theme = context.theme;
    final local = context.local;

    AppNotifier.logWithScreen("History Screen","Image: ${widget.userImage != null}");

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: complaintSuggestionProvider.loading
          ? _skeletonLoading(context)
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: complaintSuggestionList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryItemDetails(
                    item: complaintSuggestionList[index],
                    userImage: widget.userImage,
                    userInfo: widget.userInfo,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                child: ListTile(
                  title: Text(
                    complaintSuggestionList[index].fields!.title!,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "${local.issueID}: ${complaintSuggestionList[index].id!}",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.secondary),
                    ),
                  ),
                  trailing: Transform.translate(
                    offset: const Offset(10, 0),
                    child: StatusBadge(
                      status: complaintSuggestionList[index].fields!.status!,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _skeletonLoading(BuildContext context) {
  Widget skeletonBox(double height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade400,
      ),
    );
  }

  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 15,
      itemBuilder: (context, index){
        return skeletonBox(100);
      },
    ),
  );
}

