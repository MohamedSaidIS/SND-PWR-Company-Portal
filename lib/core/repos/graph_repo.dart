import '../../utils/export_import.dart';

abstract class BaseGraphRepository{
  Future<UserInfo> getUserInfo();
  Future<GroupInfo> getGroupId();
  Future<List<GroupMember>> getGroupMembers(String groupId);
}

class GraphRepository extends BaseGraphRepository{

  GraphRepository(this.apiService);

  final GraphApiService apiService;

  @override
  Future<GroupInfo> getGroupId() async{
    Map<String,dynamic> result = await apiService.get('/me');

    return GroupInfo.fromJson(result);
  }

  @override
  Future<List<GroupMember>> getGroupMembers(String groupId) async{
    Map<String,dynamic> result = await apiService.get('/me');

    return (result['value'] as List)
        .map((redirectJson) => GroupMember.fromJson(redirectJson))
        .toList();
  }

  @override
  Future<UserInfo> getUserInfo() async{
    Map<String,dynamic> result = await apiService.get('/me');

    return UserInfo.fromJson(result);
  }
}