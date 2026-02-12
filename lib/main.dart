import 'package:company_portal/di/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'utils/export_import.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("📩 Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: appProviders(localeProvider),
      child: const MyApp(),
    ),
  );
}

////////////////////////////////////////////////// App Class ////////////////////////////////////////////////////

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Builder(builder: (context) {
      return MaterialApp(
          // debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          // debugShowMaterialGrid: false,
          // // 👇
          // checkerboardRasterCacheImages: true,
          // checkerboardOffscreenLayers: true,
          debugShowCheckedModeBanner: false,
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
          navigatorKey: AppNavigator.key,
          routes: {
            '/login': (_) => const LoginScreen(),
            '/notification': (_) => const NotificationScreen(),
          });
    },);
  }
}

class AppNavigator {
  static final key = GlobalKey<NavigatorState>();

  static NavigatorState? get state => key.currentState;
}
