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
  bool _updated = false;
  String? _error;

  List<NewUserRequest> get newUserRequestList => _newUserRequestList;

  bool get loading => _loading;

  bool get updated => _updated;

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
          options:
              Options(headers: {"X-HTTP-Method": "MERGE", "If-Match": "*"}));

      if (response.statusCode == 204) {
        _updated = true;
        AppNotifier.logWithScreen(
            "New Users Request Provider", "Update New Users: $_updated");
      } else {
        _updated = false;
        _error = 'Failed to load New Users data';
        AppNotifier.logWithScreen("New Users Request Provider",
            "Update New Users Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "New Users Request Provider", "Update New Users Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createNewUserRequest(
    String title,
    String department,
    String enName,
    String arName,
    String location,
    String jobTitle,
    String mobileNo,
    String laptopNeeds,
    String specialSpecs,
    String specificSoftware,
      String currentMailToUse,
      String specifyNeedForMail,
      String specifyDynamicRole, int directManager, String joinDate,String selectedNewEmail, String selectNeedPhone, String selectedUseDynamics, String selectedDeviceType,
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await sharePointDioClient.dio.post(
        "https://alsanidi.sharepoint.com/sites/IT-Requests/_api/Web/Lists(guid'222d515f-cc0e-4deb-a088-ba22acfd129b')/items",
        data: {
            "Title": title,
            "field_1": joinDate,
            "field_2": location,
            "field_3": enName,
            "field_4": arName,
            "Title_x0020__x002d__x0020__x0627": jobTitle,
            "field_5": mobileNo,
            "field_6": department,
            "field_8": selectedDeviceType,
            "field_9": laptopNeeds,
            "field_10": specialSpecs,
            "field_11": specificSoftware,
            "field_12": selectedNewEmail,
            "Current_x0020_Email_x0020_to_x00": currentMailToUse,
            "field_14": specifyNeedForMail,
            "field_15": selectNeedPhone,
            "field_16": selectedUseDynamics,
            "field_17": specifyDynamicRole,
            "field_7Id": [directManager],
          },
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
      AppNotifier.logWithScreen("ComplaintSuggestion Provider",
          "Create New User Request Exception: $_error");
    }
    _loading = false;
    notifyListeners();
    return true;
  }
}
