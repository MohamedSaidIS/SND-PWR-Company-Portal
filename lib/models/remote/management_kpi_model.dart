
class ManagementKpiSection {
  final String sectionTitle;
  final int secWeight;
  final List<KpiItem> items;

  ManagementKpiSection({
    required this.sectionTitle,
    required this.secWeight,
    required this.items,
  });
}

class KpiItem {
  final String title;
  List<bool> ratings;
  double? weight;
  double? score;
  double? averageWeight;

  KpiItem({
    required this.title,
    required this.ratings,
    required this.weight,
    required this.score,
    required this.averageWeight,
  });
}