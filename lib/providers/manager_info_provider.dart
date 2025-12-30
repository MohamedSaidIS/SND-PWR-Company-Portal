import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class ManagerInfoProvider with ChangeNotifier {
  final GraphDioClient dioClient;

  ManagerInfoProvider({required this.dioClient});

  UserInfo? _managerInfo;
  bool _loading = false;
  String? _error;

  UserInfo? get managerInfo => _managerInfo;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> fetchManagerInfo() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get('/me/manager');

      if (response.statusCode == 200) {
        _managerInfo = await compute(
          (Map<String, dynamic> data) => UserInfo.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppLogger.info("Manager Info Provider",
            "Manager Info Fetching Success: $_managerInfo");
      } else {
        _error = 'Failed to load manager data';
        AppLogger.error("Manager Info Provider",
            "Manager Info Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "Manager Info Provider", "Manager Info Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
