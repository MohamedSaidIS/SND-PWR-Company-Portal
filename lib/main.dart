import 'package:company_portal/providers/management_kpi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/auth_controller.dart';
import 'firebase_options.dart';
import 'utils/export_import.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("📩 Handling background message: ${message.messageId}");
}

void main() async {
  // debugProfileBuildsEnabled = true;
  // debugPrintRebuildDirtyWidgets = true;
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();

  // ✅ Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthConfigController>(
          create: (_) => AuthConfigController(navigatorKey),
        ),
        Provider<GraphDioClient>(
          create: (context) => GraphDioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () async {
              AppNotifier.logWithScreen(
                  "Main Screen", "⚠️Graph Dio Unauthorized called! logout");
              AppNotifier.sessionExpiredDialog();
            },
          ),
        ),
        Provider<SharePointDioClient>(
          create: (context) => SharePointDioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () {
              AppNotifier.logWithScreen("Main Screen",
                  "⚠️SharePoint Dio Unauthorized called! logout");
              AppNotifier.sessionExpiredDialog();
            },
          ),
        ),
        Provider<MySharePointDioClient>(
          create: (context) => MySharePointDioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () {
              AppNotifier.logWithScreen("Main Screen",
                  "⚠️MySharePoint Dio Unauthorized called! logout");
              AppNotifier.sessionExpiredDialog();
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
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagerInfoProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DirectReportsProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserImageProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagementKpiProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintSuggestionProvider(
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
            mySharePointDioClient: context.read<MySharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => NewUserRequestProvider(
            sharePointDioClient: context.read<SharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VacationBalanceProvider(
            kpiDioClient: context.read<KPIDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AllOrganizationUsersProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EcommerceProvider(
            sharePointDioClient: context.read<SharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(
            sharePointDioClient: context.read<SharePointDioClient>(),
            mySharePointDioClient: context.read<MySharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AttachmentsProvider(
            sharePointDioClient: context.read<SharePointDioClient>(),
            mySharePointDioClient: context.read<MySharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DynamicsProvider(
            mySharePointDioClient: context.read<MySharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider<VacationPermissionRequestProvider>(
          create: (context) => VacationPermissionRequestProvider(
            kpiDioClient: context.read<KPIDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => localeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => FileController(),
        ),
        ChangeNotifierProvider(
          create: (_) => EcommerceFormController(),
        ),
        ChangeNotifierProvider(
          create: (_) => DynamicsFormController(),
        ),
        ChangeNotifierProvider(
          create: (_) => ComplaintSuggestionFormController(),
        ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Builder(builder: (context) {
      return MaterialApp(
          //   showPerformanceOverlay: true,
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('ur'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          theme: themeProvider.themeData,
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
          navigatorKey: navigatorKey,
          routes: {
            '/login': (context) => const LoginScreen(),
          });
    });
  }
}
