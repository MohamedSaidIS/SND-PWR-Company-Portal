import 'package:aad_oauth/aad_oauth.dart';
import 'package:company_portal/config/env_config.dart';
import 'package:company_portal/providers/all_organization_users_provider.dart';
import 'package:company_portal/providers/complaint_suggestion_provider.dart';
import 'package:company_portal/providers/direct_reports_provider.dart';
import 'package:company_portal/providers/sales_kpis_provider.dart';
import 'package:company_portal/providers/locale_provider.dart';
import 'package:company_portal/providers/manager_info_provider.dart';
import 'package:company_portal/providers/sp_ensure_user.dart';
import 'package:company_portal/providers/user_image_provider.dart';
import 'package:company_portal/providers/user_info_provider.dart';
import 'package:company_portal/service/kpi_dio_client.dart';
import 'package:company_portal/service/dio_client.dart';
import 'package:company_portal/service/shared_point_dio_client.dart';
import 'package:company_portal/splash_screen.dart';
import 'package:company_portal/theme/theme_provider.dart';
import 'package:company_portal/utils/app_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';

import 'config/auth_config.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("📩 Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  // ✅ Firebase init
  await Firebase.initializeApp();

  // ✅ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        Provider<AadOAuth>(
            create: (_) =>
                AadOAuth(AuthConfig.createMicrosoftConfig(navigatorKey))),
        Provider<DioClient>(
          create: (context) => DioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () {
              AppNotifier.loginAgain(context);
            },
          ),
        ),
        Provider<SharePointDioClient>(
          create: (context) => SharePointDioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () {
              AppNotifier.loginAgain(context);
            },
          ),
        ),
        Provider<KPIDioClient>(
          create: (_) => KPIDioClient(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<UserInfoProvider>(
          create: (context) => UserInfoProvider(
            dioClient: context.read<DioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagerInfoProvider(
            dioClient: context.read<DioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DirectReportsProvider(dioClient: context.read<DioClient>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserImageProvider(
            dioClient: context.read<DioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintSuggestionProvider(
            dioClient: context.read<DioClient>(),
            sharePointDioClient: context.read<SharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesKPIProvider(
            kpiDioClient: context.read<KPIDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SPEnsureUserProvider(
            sharePointDioClient: context.read<SharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AllOrganizationUsersProvider(
            dioClient: context.read<DioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => localeProvider,
        )
      ],
      child: const MyApp(),
    ),
  );
}

var navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Builder(builder: (context) {
      return MaterialApp(
        showPerformanceOverlay: true,
        locale: localeProvider.locale,
        supportedLocales: [localeProvider.locale],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
        //   routes: {
        //     '/home': (context) => const HomeScreen(oauth: oauth, accessToken: accessToken),
        // }
      );
    });
  }
}
