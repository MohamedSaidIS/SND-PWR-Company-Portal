import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:company_portal/utils/export_import.dart';
List<SingleChildWidget> appProviders(LocaleProvider localeProvider) {
  return [
    Provider<AuthConfigController>(
      create: (_) => AuthConfigController(AppNavigator.key),
    ),
    Provider<GraphDioClient>(create: (_) => GraphDioClient()),
    Provider<SharePointDioClient>(create: (_) => SharePointDioClient()),
    Provider<MySharePointDioClient>(create: (_) => MySharePointDioClient()),
    Provider<KPIDioClient>(create: (_) => KPIDioClient()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider<UserInfoProvider>(
      create: (context) => UserInfoProvider(
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
      create: (_) => NotificationProvider()..load(),
    ),
  ];
}
