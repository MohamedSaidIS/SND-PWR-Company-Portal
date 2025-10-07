class SupportItem {
  final String name;
  final String image;

  const SupportItem({
    required this.name,
    required this.image,
  });
}

List<SupportItem> getSupportItems = [
  const SupportItem(
    name: "Issue and Request \nTracking",
    image: 'assets/images/issue_tracker.png',
  ),
  const SupportItem(
    name: "Users New \nRequests",
    image: 'assets/images/user_new_request.png',
  ),
  const SupportItem(
    name: "Dynamic365 \nSupport Cases",
    image: 'assets/images/dynamics_support.png',
  ),
  const SupportItem(
    name: "ECommerce \nSupport Cases",
    image: 'assets/images/ecommerce.png',
  ),
];
