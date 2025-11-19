import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/export_import.dart';

class PreviousRequestScreen extends StatefulWidget {
  const PreviousRequestScreen({super.key});

  @override
  State<PreviousRequestScreen> createState() => _PreviousRequestScreenState();
}

class _PreviousRequestScreenState extends State<PreviousRequestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = context.read<VacationPermissionRequestProvider>();
      await provider.getPreviousRequests("");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final locale = context.currentLocale();

    return Scaffold(
      body: Consumer<VacationPermissionRequestProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);

          final previousRequests = provider.previousRequests;
          return ListView.builder(
            itemCount: previousRequests.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              var item = previousRequests[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      item.absenceCode,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20),
                      child: Transform.translate(
                        offset: Offset(locale == "en" ? -20 : 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${local.from}: ${formateDate(item.startDateTime!, locale)}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary),
                            ),
                            Text(
                              "${local.to}: ${formateDate(item.endDateTime!, locale)}",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    trailing: Transform.translate(
                      offset: Offset(locale == "en" ? 10 : -10, 0),
                      child: BadgeWidget(
                          translatedTitle:
                              getTranslatedApproval(item.approved, local),
                          color: getApprovalColor(item.approved),
                          icon: getApprovalIcon(item.approved)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String formateDate(DateTime date, String locale) {
    return DateFormat(locale == 'ar' ? 'yyyy/MM/dd' : 'dd/MM/yyyy', locale)
        .format(DateTime.now());
  }
}
