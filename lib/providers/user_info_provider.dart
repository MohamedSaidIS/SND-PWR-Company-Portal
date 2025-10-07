
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
  bool _loading = false;
  String? _error;

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


  Future<void> getGroupId() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await dioClient.dio.post("/me/checkMemberGroups", data: {
        "groupIds": [
          "1ea1d494-a377-4071-beac-301a99746d2a",
          "9876abcd-4321-aaaa-9999-bbbbbccccddd"
        ]
      });
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

        AppNotifier.logWithScreen(
          "UserInfo Provider",
          "Group Info Parsed: $_groupInfo",
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

}
