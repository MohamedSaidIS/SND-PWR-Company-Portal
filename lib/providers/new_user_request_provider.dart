import 'package:company_portal/models/remote/new_user_request.dart';
import 'package:company_portal/service/shared_point_dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_notifier.dart';

class NewUserRequestProvider extends ChangeNotifier {
  final SharePointDioClient sharePointDioClient;

  NewUserRequestProvider({required this.sharePointDioClient});

  List<NewUserRequest> _newUserRequestList = [];
  bool _loading = false;
  String? _error;

  List<NewUserRequest> get newUserRequestList => _newUserRequestList;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> getNewUserRequest() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.get(
          "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items");

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _newUserRequestList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => NewUserRequest.fromJson(e as Map<String, dynamic>))
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
              "New Users Fetching: ${response.statusCode} ${_newUserRequestList[0].arName}")
          : AppNotifier.logWithScreen("New Users Request Provider",
              "Vacation Transactions Fetching: ${response.statusCode}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "New Users Request Provider", "New Users Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> updateNewUserRequest(int requestId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items($requestId)",
        data: {},
        options: Options(
          headers: {
            "X-HTTP-Method":"MERGE",
            "If-Match":"*"
          }
        )
      );

      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _newUserRequestList = await compute(
          (final data) => (data['value'] as List)
              .map((e) => NewUserRequest.fromJson(e as Map<String, dynamic>))
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
              "New Users Fetching: ${response.statusCode} ${_newUserRequestList[0].arName}")
          : AppNotifier.logWithScreen("New Users Request Provider",
              "Vacation Transactions Fetching: ${response.statusCode}");
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "New Users Request Provider", "New Users Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
