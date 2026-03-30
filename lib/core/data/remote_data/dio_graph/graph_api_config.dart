class GraphApiConfig{
  /// EndPoints
  static const String userInfo = '/me';
  static const String checkMemberGroup = '/me/checkMemberGroups';
  static const String userImage = '/me/photo/\$value';
  static const String userManager = '/me/manager';
  static const String directReports = '/me/directReports';
  static const String allUsers = '/users?\$top=999';
  static String groupMembers({required String groupId}) => "/groups/$groupId/members";
}