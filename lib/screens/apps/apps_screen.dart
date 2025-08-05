import 'package:company_portal/data/app_data.dart';
import 'package:company_portal/utils/context_extensions.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              itemCount: apps.length,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet? 3 : 2, // two columns
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = apps[index];
                  return _buildAppCard(
                      _buildCardInfo(item.appIcon, item.appName, isTablet),
                      item.packageName,
                      context,
                      theme, local);
                }),
          )),
    );
  }
}

Widget _buildAppCard(
    Widget child, String packageName, BuildContext context, ThemeData theme, AppLocalizations local) {
  return GestureDetector(
      onTap: () {
        openAppOrRedirect(packageName, context, local);
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

void openAppOrRedirect(String packageName, BuildContext context, AppLocalizations local) async {
  await Future.delayed(const Duration(seconds: 1));
  if (packageName == "") {
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
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: false,
    );
    bool isInstalled = apps.any((app) => app.packageName == packageName);
    print("Installed App: $isInstalled");
    for( Application app in apps){
      print("App Name: ${app.appName}, Package: ${app.packageName}");
    }

    if (isInstalled) {
      DeviceApps.openApp(packageName);
    } else {
      final Uri uri = Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName");
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    }
  }
}
