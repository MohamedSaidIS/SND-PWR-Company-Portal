import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/export_import.dart';

class DirectReportsScreen extends StatefulWidget {
  const DirectReportsScreen({super.key,});

  @override
  State<DirectReportsScreen> createState() => _DirectReportsScreenState();
}

class _DirectReportsScreenState extends State<DirectReportsScreen> {

  @override
  Widget build(BuildContext context) {
    final directReportListProvider = context.watch<DirectReportsProvider>();
    final directReportList = directReportListProvider.directReportList;
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.directReport,
          backBtn: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: directReportListProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : directReportListProvider.error != null
              ? Center(
              child: Text("Error: ${directReportListProvider.error}"))
              : directReportListProvider.directReportList == null
              ? const Center(child: CircularProgressIndicator())
              : directReportListProvider.directReportList!.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Text(
                  "${local.yourTeamMembers}:",
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: directReportList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0),
                      child: DirectReportCardWidget(
                          directReportItem:
                          directReportList[index]),
                    );
                  },
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 220,
                  child: Image.asset(
                      "assets/images/no_team_member.png"),
                ),
                const SizedBox(height: 30),
                Text(
                  local.noTeamMembersAssigned,
                  style: theme.textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  local
                      .thereAreCurrentlyNoTeamMembersAssignedToYouForDisplay,
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
