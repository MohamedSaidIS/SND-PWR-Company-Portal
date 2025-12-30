import 'package:flutter/foundation.dart';
import '../utils/export_import.dart';

class UserInfoProvider with ChangeNotifier {
  final GraphDioClient dioClient;

  UserInfoProvider({required this.dioClient});

  UserInfo? _userInfo;
  GroupInfo? _groupInfo;
  List<GroupMember>? _groupMembers;
  ViewState _state = ViewState.loading;
  String? _error;

  UserInfo? get userInfo => _userInfo;

  GroupInfo? get groupInfo => _groupInfo;

  List<GroupMember>? get groupMembers => _groupMembers;

  ViewState get state => _state;

  String? get error => _error;

  Future<void> fetchUserInfo() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get('/me');
      if (response.statusCode == 200) {
        _userInfo = await compute(
          (Map<String, dynamic> data) => UserInfo.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        AppLogger.info("UserInfo Provider", "UserInfo Fetching: $_userInfo");
        if (_userInfo == null) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to load user data';
        _state = ViewState.error;

        AppLogger.error("UserInfo Provider",
            "UserInfo Error: $_error ${response.statusCode}");
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;
      AppLogger.error(
          "UserInfo Provider", "UserInfo Exception: $_error");
    }
    notifyListeners();
  }

  Future<void> getGroupId() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.post(
        "/me/checkMemberGroups",
        data: {
          "groupIds": [
            "6ca3fd12-cda4-4c3a-882d-a5da6a1e3c1b",
            "4053f91a-d9a0-4a65-8057-1a816e498d0f",
            "1ea1d494-a377-4071-beac-301a99746d2a"
          ]
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> matchedGroupIds = response.data["value"];
        _groupInfo = await compute(
          (List<dynamic> ids) {
            AppLogger.info(
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

        AppLogger.info(
          "UserInfo Provider",
          "Group Info Parsed: $_groupInfo ${_groupInfo?.groupId}",
        );
        if (_groupInfo == null) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to get group info';
        _state = ViewState.error;

        AppLogger.error("UserInfo Provider",
            "Group Info Error: $_error ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;
      AppLogger.error(
          "UserInfo Provider", "Group Info  Exception: $_error");
    }
    notifyListeners();
  }

  Future<void> getGroupMembers(String groupId) async {
    _state = ViewState.loading;
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

        AppLogger.info(
          "UserInfo Provider",
          "Group Members Parsed: ${_groupMembers?[0].displayName} ${_groupMembers?[0].givenName}",
        );

        if (_groupMembers == null || _groupMembers!.isEmpty) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to get group info';
        _state = ViewState.error;

        AppLogger.error("UserInfo Provider",
            "Group Members Error: $_error ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;

      AppLogger.error(
          "UserInfo Provider", "Group Members  Exception: $_error");
    }
    notifyListeners();
  }
}
