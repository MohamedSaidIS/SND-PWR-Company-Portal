import 'package:company_portal/models/remote/new_user_request.dart';
import 'package:company_portal/service/share_point_dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_notifier.dart';

class NewUserRequestProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  NewUserRequestProvider({required this.sharePointDioClient});

  List<NewUserRequest> _newUserRequestList = [];
  bool _loading = false;
  bool _updated = false;
  String? _error;

  List<NewUserRequest> get newUserRequestList => _newUserRequestList;

  bool get loading => _loading;

  bool get updated => _updated;

  String? get error => _error;

  Future<void> getNewUserRequest(int ensureUserId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.get(
          "/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items");

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _newUserRequestList = await compute(
              (final data) => (data['value'] as List)
              .map((e) => NewUserRequest.fromJson(e as Map<String, dynamic>))
              .where((req) => req.directManagerId == ensureUserId)
              .toList(),
          parsedResponse,
        );
      } else {
        _error = 'Failed to load New Users data';
        AppNotifier.logWithScreen("New Users Request Provider",
            "New Users Error: $_error ${response.statusCode}");
      }
      _newUserRequestList.isNotEmpty
          ? AppNotifier.logWithScreen("New Users Request Provider",
          "New Users Fetching: ${response.statusCode} ${_newUserRequestList[0].directManagerId}")
          : AppNotifier.logWithScreen("New Users Request Provider",
          "New Users Fetching: ${response.statusCode} ${_newUserRequestList.length}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "New Users Request Provider", "New Users Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateNewUserRequest(int requestId, NewUserRequest item) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items($requestId)",
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
        AppNotifier.logWithScreen(
            "New Users Request Provider", "Update New Users: $_updated");
        await getNewUserRequest(item.directManagerId);

        return true;
      } else {
        _updated = false;
        _error = 'Failed to load New Users data';
        AppNotifier.logWithScreen("New Users Request Provider",
            "Update New Users Error: $_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "New Users Request Provider", "Update New Users Exception: $_error");
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createNewUserRequest(NewUserRequest item) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items",
        data: item.toJson(),
      );

      if (response.statusCode == 201) {
        AppNotifier.logWithScreen("New Users Request Provider",
            "Create New User Request: Success ${response.statusCode}");
        return true;
      } else {
        _error = 'Failed to send ComplaintSuggestion data';
        AppNotifier.logWithScreen("ComplaintSuggestion Provider",
            "Create New User Request Error:$_error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
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
