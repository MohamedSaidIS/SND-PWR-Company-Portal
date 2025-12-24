import 'package:company_portal/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class NoAttachments extends StatelessWidget {
  const NoAttachments({super.key});

  @override
  Widget build(BuildContext context) {
    final local = context.local;
    final theme = context.theme;

    return  Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
            theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.no_sim_sharp,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              local.noAttachments,
              style: const TextStyle(color: Color(0xff5A5959)),
            ),
          ),
        ],
      ),
    );
  }
}
