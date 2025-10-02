class GroupInfo {
  final String groupId;
  final String? groupName;

  GroupInfo({
    required this.groupId,
    required this.groupName,
  });

  factory GroupInfo.fromJson(Map<String, dynamic> json){
    return GroupInfo(
      groupId: json ['id'],
      groupName: json ['displayName'],
    );
  }

}
