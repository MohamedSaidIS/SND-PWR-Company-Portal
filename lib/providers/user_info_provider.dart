import 'package:company_portal/data/user_data.dart';
import 'package:company_portal/service/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../models/remote/group_info.dart';
import '../models/remote/user_info.dart';
import '../utils/app_notifier.dart';

class UserInfoProvider with ChangeNotifier {
  final DioClient dioClient;

  UserInfoProvider({required this.dioClient});

  UserInfo? _userInfo;
  GroupInfo? _groupInfo;
  bool _loading = false;
  String? _error;
  List<String> groupsIds = getGroupsIds();

  UserInfo? get userInfo => _userInfo;

  GroupInfo? get groupInfo => _groupInfo;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> fetchUserInfo() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.get('/me');
      if (response.statusCode == 200) {
        _userInfo = UserInfo.fromJson(response.data);
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

  Future<void> getGroupId() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.post(
          "/me/checkMemberGroups",
        data: {
          "groupIds": [
            "1ea1d494-a377-4071-beac-301a99746d2a",
            "9876abcd-4321-aaaa-9999-bbbbbccccddd"
          ]
        }
      );
      if (response.statusCode == 200) {
        final List<dynamic> matchedGroupIds = response.data["value"];
        if (matchedGroupIds.isNotEmpty) {
          print("User is member of these groups: $matchedGroupIds");
          _groupInfo = GroupInfo(
            groupId: matchedGroupIds.first,
            groupName: "Matched Group",
          );
        } else {
          print("User is not in any of the groups");
          _groupInfo = GroupInfo(groupId: "0", groupName: "0");
        }
      } else {
        print("Error: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      _error = e.toString();
      AppNotifier.logWithScreen(
          "UserInfo Provider", "GroupId Exception: $_error");
    }
    _loading = false;
    notifyListeners();
  }
}
