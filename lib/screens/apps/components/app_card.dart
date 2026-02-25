import 'dart:io';

import 'package:company_portal/models/local/app_model.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/app_notifier.dart';

class AppCard extends StatelessWidget {
  final AppItem item;

  const AppCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        openAppOrRedirect(
            androidPackageName: item.packageName,
            iosAppId: item.iosAppId,
            context: context,
            local: local,
            theme: theme);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: Image.asset(item.appIcon),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                item.appName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openAppOrRedirect({
  required String androidPackageName,
  required String iosAppId,
  required BuildContext context,
  required AppLocalizations local,
  required ThemeData theme,
  String? iosCustomScheme,
}) async {
  if (androidPackageName.isEmpty && iosAppId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(local.thisAppIsNotExists),
        action: SnackBarAction(
          label: local.ok,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  } else {
    AppNotifier.showLoadingDialog(context, local.openingApp, theme);

    try {
      if (Platform.isAndroid) {
        List<Application> apps = await DeviceApps.getInstalledApplications(
          includeSystemApps: true,
          onlyAppsWithLaunchIntent: false,
        );

        bool isInstalled =
            apps.any((app) => app.packageName == androidPackageName);
        AppNotifier.logWithScreen("App Screen", "Installed App: $isInstalled");

        if (isInstalled) {
          DeviceApps.openApp(androidPackageName);
        } else {
          final Uri uri = Uri.parse(
              "https://play.google.com/store/apps/details?id=$androidPackageName");
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $uri';
          }
        }
      } else if (Platform.isIOS) {
        bool isSimulator = !Platform.isIOS ||
            Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
        if (isSimulator) {
          final Uri testUri = Uri.parse("https://apple.com");
          await launchUrl(testUri, mode: LaunchMode.externalApplication);
          return;
        }
        bool opened = false;
        if (iosCustomScheme != null && iosCustomScheme.isNotEmpty) {
          final Uri customUri = Uri.parse(iosCustomScheme);
          if (await canLaunchUrl(customUri)) {
            await launchUrl(customUri, mode: LaunchMode.externalApplication);
            opened = true;
          }
        }
        if (!opened) {
          final Uri appStoreUri =
              Uri.parse("https://apps.apple.com/eg/app/$iosAppId");
          if (!await launchUrl(appStoreUri,
              mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $appStoreUri';
          }
        }
      }
    } finally {
      AppNotifier.hideLoadingDialog(context);
    }
  }
}
