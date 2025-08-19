import 'dart:io';

import 'package:company_portal/data/apps_data.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final isTablet = context.isTablet();

    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: theme.appBarTheme.backgroundColor,
            automaticallyImplyLeading: false,
            title: Text(local.apps,
                style: theme.textTheme.headlineLarge
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
            child: GridView.builder(
              itemCount: getAppItems.length,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet? 3 : 2, // two columns
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = getAppItems[index];
                  return _buildAppCard(
                      _buildCardInfo(item.appIcon, item.appName, isTablet),
                      item.packageName,
                      item.iosAppId,
                      context,
                      theme, local);
                }),
          )
      ),
    );
  }
}

Widget _buildAppCard(
    Widget child, String packageName, String iosAppId, BuildContext context, ThemeData theme, AppLocalizations local) {
  return GestureDetector(
      onTap: () {
        openAppOrRedirect(androidPackageName: packageName, iosAppId: iosAppId, context: context, local: local);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
          child: child,
        ),
      ));
}

Widget _buildCardInfo(String iconStr, String text, bool isTablet) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconStr,
          scale: isTablet? 1: 1.4,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            text,
            style: TextStyle(fontSize: isTablet? 20: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ]);
}

Future<void> openAppOrRedirect({
  required String androidPackageName,
  required String iosAppId,
  required BuildContext context,
  required AppLocalizations local,
  String? iosCustomScheme, // optional, e.g. "fb://"
}) async {
  await Future.delayed(const Duration(seconds: 1));

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
    return;
  }

  if (Platform.isAndroid) {
    // Check if installed
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: false,
    );

    bool isInstalled = apps.any((app) => app.packageName == androidPackageName);
    print("Installed App: $isInstalled");

    if (isInstalled) {
      DeviceApps.openApp(androidPackageName);
    } else {
      final Uri uri = Uri.parse(
          "https://play.google.com/store/apps/details?id=$androidPackageName");
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    }
  }

  else if (Platform.isIOS) {
    bool isSimulator =
        !Platform.isIOS || Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');

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
}
