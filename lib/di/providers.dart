import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../utils/export_import.dart';

List<SingleChildWidget> appProviders(LocaleProvider localeProvider) {
  return [
    Provider<AuthConfigController>(
      create: (_) => AuthConfigController(AppNavigator.key),
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
          AppNotifier.logWithScreen(
              "Main Screen", "⚠️SharePoint Dio Unauthorized called! logout");
          AppNotifier.sessionExpiredDialog();
        },
      ),
    ),
    Provider<MySharePointDioClient>(
      create: (context) => MySharePointDioClient(
        appAuth: const FlutterAppAuth(),
        onUnauthorized: () {
          AppNotifier.logWithScreen(
              "Main Screen", "⚠️MySharePoint Dio Unauthorized called! logout");
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
    ChangeNotifierProvider(
      create: (_) => NotificationProvider()..load(),
    ),
  ];
}
