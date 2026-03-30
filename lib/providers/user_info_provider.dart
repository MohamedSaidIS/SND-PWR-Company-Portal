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
      final response = await dioClient.get(GraphApiConfig.userInfo);
      if (response.statusCode == 200) {
        _userInfo = await compute(
          (Map<String, dynamic> data) => UserInfo.fromJson(data),
          Map<String, dynamic>.from(response.data),
        );
        if (_userInfo == null) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to load user data';
        _state = ViewState.error;
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> getGroupId() async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.post(
        GraphApiConfig.checkMemberGroup,
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
        if (_groupInfo == null) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to get group info';
        _state = ViewState.error;
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> getGroupMembers(String groupId) async {
    _state = ViewState.loading;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get(GraphApiConfig.groupMembers(groupId: groupId));
      if (response.statusCode == 200) {
        final parsedResponse = response.data;
        _groupMembers = await compute(
          (final data) => (data['value'] as List)
              .map((redirectJson) => GroupMember.fromJson(redirectJson))
              .toList(),
          parsedResponse,
        );
        if (_groupMembers == null || _groupMembers!.isEmpty) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.data;
        }
      } else {
        _error = 'Failed to get group info';
        _state = ViewState.error;
      }
    } catch (e) {
      _error = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }
}
