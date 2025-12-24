import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/export_import.dart';

class PreviousRequestScreen extends StatefulWidget {
  final String? personnelNumber;

  const PreviousRequestScreen({required this.personnelNumber, super.key});

  @override
  State<PreviousRequestScreen> createState() => _PreviousRequestScreenState();
}

class _PreviousRequestScreenState extends State<PreviousRequestScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = context.read<VacationPermissionRequestProvider>();
      await provider.getPreviousRequests(widget.personnelNumber?? "");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = context.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VacationPermissionRequestProvider>(
        builder: (context, provider, _) {
          if (provider.loading) return AppNotifier.loadingWidget(theme);
          if(provider.error != null) return Text("${provider.error}");
          final previousRequests = provider.previousRequests;
          return ListView.builder(
            itemCount: previousRequests.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              var item = previousRequests[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      PreviousRequestItem(item: item),
                      PreviousRequestAttachments(item: item)
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
