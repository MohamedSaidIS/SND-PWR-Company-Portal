import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:company_portal/utils/export_import.dart';

class NewUserRequestProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  NewUserRequestProvider({required this.sharePointDioClient});

  List<NewUserItem> _newUserRequestList = [];
  bool _loading = false;
  bool _updated = false;
  String? _error;

  List<NewUserItem> get newUserRequestList => _newUserRequestList;

  bool get loading => _loading;

  bool get updated => _updated;

  String? get error => _error;

  Future<void> getNewUserRequest(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.get(ShareApiConfig.newUserItems);

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _newUserRequestList = await compute(
              (final data) => (data['value'] as List)
              .map((e) => NewUserItem.fromJson(e as Map<String, dynamic>))
              .where((req) => req.directManagerId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load New Users data';
        AppLogger.error("New Users Request Provider",
            "New Users Error: $_error ${response.statusCode}");
      }
      _newUserRequestList.isNotEmpty
          ? AppLogger.info("New Users Request Provider",
          "New Users Fetching: ${response.statusCode} ${_newUserRequestList[0].directManagerId}")
          : AppLogger.info("New Users Request Provider",
          "New Users Fetching: ${response.statusCode} ${_newUserRequestList.length}");
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "New Users Request Provider", "New Users Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateNewUserRequest(int requestId, NewUserItem item) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        ShareApiConfig.updateNewUserItem(requestId: requestId),
        data: item.toJson(),
        options: Options(
          headers: {
            "X-HTTP-Method": "MERGE",
            "If-Match": "*",
          },
        ),
      );

      if (response.statusCode == 204) {
        _updated = true;
        AppLogger.info(
            "New Users Request Provider", "Update New Users: $_updated");
        await getNewUserRequest(item.directManagerId);

        return true;
      } else {
        _updated = false;
        _error = 'Failed to load New Users data';
        AppLogger.error("New Users Request Provider",
            "Update New Users Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
          "New Users Request Provider", "Update New Users Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createNewUserRequest(NewUserItem item) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.post(
        ShareApiConfig.newUserItems,
        data: item.toJson(),
      );

      if (response.statusCode == 201) {
        AppLogger.info("New Users Request Provider",
            "Create New User Request: Success ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to send ComplaintSuggestion data';
        AppLogger.error("ComplaintSuggestion Provider",
            "Create New User Request Error:$_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppLogger.error(
        "ComplaintSuggestion Provider",
        "Create New User Request Exception: $_error",
      );
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
