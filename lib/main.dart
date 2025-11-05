import 'package:aad_oauth/aad_oauth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/export_import.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  debugPrint("📩 Handling background message: ${message.messageId}");
}

void main() async {
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
        Provider<AadOAuth>(
            create: (_) =>
                AadOAuth(AuthConfig.createMicrosoftConfig(navigatorKey))),
        Provider<GraphDioClient>(
          create: (context) => GraphDioClient(
            appAuth: const FlutterAppAuth(),
            onUnauthorized: () {
              print("⚠️ Unauthorized called! logout");
              navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
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
        Provider<MySharePointDioClient>(
          create: (context) => MySharePointDioClient(
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
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ManagerInfoProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              DirectReportsProvider(dioClient: context.read<GraphDioClient>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserImageProvider(
            dioClient: context.read<GraphDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintSuggestionProvider(
            dioClient: context.read<GraphDioClient>(),
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
          create: (context) => DynamicsProvider(
            mySharePointDioClient: context.read<MySharePointDioClient>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => localeProvider,
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

    return Builder(builder: (context) {
      return MaterialApp(
        //   showPerformanceOverlay: true,
        locale: localeProvider.locale,
        supportedLocales: [localeProvider.locale],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        theme: Provider.of<ThemeProvider>(context).themeData,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
          routes: {
            '/login': (context) => const LoginScreen(),
        }
      );
    });
  }
}
