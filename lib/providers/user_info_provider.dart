import 'package:company_portal/models/remote/group_member.dart';
import 'package:company_portal/service/graph_dio_client.dart';
import 'package:flutter/foundation.dart';
import '../models/remote/group_info.dart';
import '../models/remote/user_info.dart';
import '../utils/app_notifier.dart';

class UserInfoProvider with ChangeNotifier {
  final GraphDioClient dioClient;

  UserInfoProvider({required this.dioClient});

  UserInfo? _userInfo;
  GroupInfo? _groupInfo;
  List<GroupMember>? _groupMembers;
  bool _loading = false;
  String? _error;

  UserInfo? get userInfo => _userInfo;

  GroupInfo? get groupInfo => _groupInfo;

  List<GroupMember>? get groupMembers => _groupMembers;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> fetchUserInfo() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get('/me');
      if (response.statusCode == 200) {
        _userInfo = await compute(
          (Map<String, dynamic> data) => UserInfo.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppNotifier.logWithScreen(
            "UserInfo Provider", "UserInfo Fetching: $_userInfo");
      } else {
        _error = 'Failed to load user data';
        AppNotifier.logWithScreen("UserInfo Provider",
            "UserInfo Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "UserInfo Provider", "UserInfo Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getGroupId(bool isManager) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.post(
        "/me/checkMemberGroups",
        data: isManager
            ? {
                "groupIds": [
                  "6ca3fd12-cda4-4c3a-882d-a5da6a1e3c1b", // sales managers
                ]
              }
            : {
                "groupIds": [
                  "4053f91a-d9a0-4a65-8057-1a816e498d0f", // sales
                  "1ea1d494-a377-4071-beac-301a99746d2a" // management
                ]
              },
      );
      if (response.statusCode == 200) {
        final List<dynamic> matchedGroupIds = response.data["value"];
        _groupInfo = await compute(
          (List<dynamic> ids) {
            AppNotifier.logWithScreen(
              "UserInfo Provider",
              "Group Info Parsed: $ids ${ids[0]}",
            );
            if (ids.isNotEmpty) {
              return GroupInfo(
                groupId: ids.first,
                groupName: "Matched Group",
              );
            } else {
              return GroupInfo(groupId: "0", groupName: "0");
            }
          },
          matchedGroupIds,
        );

        AppNotifier.logWithScreen(
          "UserInfo Provider",
          "Group Info Parsed: $_groupInfo ${_groupInfo?.groupId}",
        );
      } else {
        _error = 'Failed to get group info';
        AppNotifier.logWithScreen("UserInfo Provider",
            "Group Info Error: $_error ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "UserInfo Provider", "Group Info  Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getGroupMembers(String groupId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.get("/groups/$groupId/members");
      if (response.statusCode == 200) {
        AppNotifier.logWithScreen(
          "UserInfo Provider",
          "Group Members Parsed: ${response.statusCode}",
        );
        final parsedResponse = response.data;
        _groupMembers = await compute(
          (final data) => (data['value'] as List)
              .map((redirectJson) => GroupMember.fromJson(redirectJson))
              .toList(),
          parsedResponse,
        );

        AppNotifier.logWithScreen(
          "UserInfo Provider",
          "Group Members Parsed: $_groupMembers",
        );
      } else {
        _error = 'Failed to get group info';
        AppNotifier.logWithScreen("UserInfo Provider",
            "Group Members Error: $_error ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "UserInfo Provider", "Group Members  Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
