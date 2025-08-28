import 'package:company_portal/screens/account/complaint_suggestion/widgets/status_badge.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/complaint_suggestion_provider.dart';
import 'history_item_details.dart';

class HistoryScreen extends StatefulWidget {
  final String userId;

  const HistoryScreen({required this.userId, super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintSuggestionProvider =
          context.read<ComplaintSuggestionProvider>();

      complaintSuggestionProvider.fetchSuggestionsAndComplaints(widget.userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final complaintSuggestionProvider =
        context.watch<ComplaintSuggestionProvider>();
    final complaintSuggestionList =
        complaintSuggestionProvider.complaintSuggestionList!.toList();

    final theme = context.theme;
    final local = context.local;

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
                      padding: const EdgeInsets.all(8.0),
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
                        trailing: StatusBadge(
                          status: complaintSuggestionList[index].fields!.status!,
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

