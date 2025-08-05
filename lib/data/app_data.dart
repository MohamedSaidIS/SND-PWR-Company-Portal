class AppItem {
  final String appIcon;
  final String appName;
  final String packageName;

  const AppItem({
    required this.appIcon,
    required this.appName,
    required this.packageName,
  });
}

final List<AppItem> apps = [
  const AppItem(
      appIcon: 'assets/images/calender_icon.png',
      appName: 'Calendar',
      packageName: ''),
  const AppItem(
      appIcon: 'assets/images/connection_icon.png',
      appName: 'Connection',
      packageName: ''),
  const AppItem(
      appIcon: 'assets/images/engage_icon.png',
      appName: 'Engage',
      packageName: 'com.yammer.v1'),
  const AppItem(
      appIcon: 'assets/images/excel_icon.png',
      appName: 'Excel',
      packageName: 'com.microsoft.office.excel'),
  const AppItem(
      appIcon: 'assets/images/insight_icon.png',
      appName: 'Insight',
      packageName: ''),
  const AppItem(
      appIcon: 'assets/images/on_drive_icon.png',
      appName: 'OnDrive',
      packageName: 'com.microsoft.skydrive'),
  const AppItem(
      appIcon: 'assets/images/onenote_icon.png',
      appName: 'OneNote',
      packageName: 'com.microsoft.office.onenote'),
  const AppItem(
      appIcon: 'assets/images/outlook_icon.png',
      appName: 'OutLook',
      packageName: 'com.microsoft.office.outlook'),
  const AppItem(
      appIcon: 'assets/images/planner_icon.png',
      appName: 'Planner',
      packageName: 'com.microsoft.planner'),
  const AppItem(
      appIcon: 'assets/images/power_app_icon.png',
      appName: 'PowerApp',
      packageName: 'com.microsoft.msapps'),
  const AppItem(
      appIcon: 'assets/images/power_point_icon.png',
      appName: 'PowerPoint',
      packageName: 'com.microsoft.office.powerpoint'),
  const AppItem(
      appIcon: 'assets/images/stream_icon.png',
      appName: 'Stream',
      packageName: ''),
  const AppItem(
      appIcon: 'assets/images/teams_icon.png',
      appName: 'Teams',
      packageName: 'com.microsoft.teams'),
  const AppItem(
      appIcon: 'assets/images/to_do_icon.png',
      appName: 'ToDo',
      packageName: 'com.microsoft.todos'),
  const AppItem(
      appIcon: 'assets/images/word_icon.png',
      appName: 'Word',
      packageName: 'com.microsoft.office.word'),
];
