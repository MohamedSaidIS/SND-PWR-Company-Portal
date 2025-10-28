import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';


class SPEnsureUserProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;
  final MySharePointDioClient mySharePointDioClient;

  SPEnsureUserProvider({required this.sharePointDioClient, required this.mySharePointDioClient});

  EnsureUser? _itSiteEnsureUser;
  EnsureUser? _alsanidiSiteEnsureUser;
  EnsureUser? _dynamicsEnsureUser;
  bool _loading = false;
  String? _error;

  EnsureUser? get itEnsureUser => _itSiteEnsureUser;
  EnsureUser? get alsanidiSiteEnsureUser => _alsanidiSiteEnsureUser;
  EnsureUser? get dynamicsEnsureUser => _dynamicsEnsureUser;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> fetchITSiteEnsureUser(String email, BuildContext context) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        "/sites/IT-Requests/_api/web/ensureuser",
        data: {
          "logonName": "i:0#.f|membership|$email",
        },
      );
      if (response.statusCode == 200) {
        _itSiteEnsureUser = await compute(
          (Map<String, dynamic> data) => EnsureUser.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Ensure User Provider",
            "IT Ensure User Fetching: ${_itSiteEnsureUser?.id.toString()}");
      } else {
        _error = 'Failed to load ensure user data ${response.statusCode}';
        AppNotifier.logWithScreen(
            "IT Ensure User Provider", "Ensure User Exception: $_error");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ensure UserProvider", "IT Ensure User Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchAlsanidiSiteEnsureUser(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "/sites/AbdulrahmanHamadAlsanidi/_api/web/ensureuser",
        data: {
          "logonName": "i:0#.f|membership|$email",
        },
      );
      if (response.statusCode == 200) {
        _alsanidiSiteEnsureUser = await compute(
              (Map<String, dynamic> data) => EnsureUser.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Ensure User Provider",
            "Alsanidi Ensure User Fetching: ${_alsanidiSiteEnsureUser?.id.toString()}");
      } else {
        _error = 'Failed to load ensure user data ${response.statusCode}';
        AppNotifier.logWithScreen(
            "Ensure User Provider", "Alsanidi Ensure User Exception: $_error");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ensure UserProvider", "Alsanidi Ensure User Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchDynamicsSiteEnsureUser(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await mySharePointDioClient.post(
        "/_api/Web/ensureuser",
        data: {
          "logonName": "i:0#.f|membership|$email",
        },
      );
      if (response.statusCode == 200) {
        _dynamicsEnsureUser = await compute(
              (Map<String, dynamic> data) => EnsureUser.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen("Ensure User Provider",
            "Dynamics Ensure User Fetching: ${_dynamicsEnsureUser?.id.toString()} ${_dynamicsEnsureUser?.email.toString()}");
      } else {
        _error = 'Failed to load ensure user data ${response.statusCode}';
        AppNotifier.logWithScreen(
            "Ensure User Provider", "Dynamics Ensure User Exception: $_error");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "Ensure UserProvider", "Dynamics Ensure User Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
