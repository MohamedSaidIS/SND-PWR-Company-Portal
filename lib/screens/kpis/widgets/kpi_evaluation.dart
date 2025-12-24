import 'package:flutter/material.dart';

import '../../../models/remote/management_kpi_model.dart';

class KpiEvaluationScreen extends StatelessWidget {
  final List<ManagementKpiSection> items;

  const KpiEvaluationScreen({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OverallScoreCard(items: items),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return KpiSection(
                      title: item.sectionTitle,
                      weight: item.secWeight,
                      items: item.items);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KpiSection extends StatelessWidget {
  final String title;
  final int weight;
  final List<KpiItem> items;

  const KpiSection({
    super.key,
    required this.title,
    required this.weight,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  theme.navigationBarTheme.backgroundColor!
                      .withValues(alpha: 0.9),
                  theme.navigationBarTheme.backgroundColor!
                      .withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                Text(
                  "$weight%",
                  style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ...items.map(
            (e) => KpiRow(item: e),
          ),
        ],
      ),
    );
  }
}

class KpiRow extends StatelessWidget {
  final KpiItem item;

  const KpiRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(item.title, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 10),
                    ),
                    Icon(
                      evaluationGrade(item.ratings, index + 1)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool evaluationGrade(List<bool> ratings, int index) {
    int value = 0;
    for (var i in ratings) {
      if (i == true) {
        value = ratings.indexOf(i) + 1;
      }
    }
    return index == value ? true : false;
  }
}

class OverallScoreCard extends StatelessWidget {
  final List<ManagementKpiSection> items;

  const OverallScoreCard({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Score',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        color: theme.colorScheme.secondary,
                        value: calculateOverAllPercentage(items) / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  Text(
                    '${calculateOverAllPercentage(items).toStringAsFixed(2)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double calculateOverAllPercentage(List<ManagementKpiSection> items) {
    double overallPercentage = 0.0;
    for (var item in items) {
      for (var i in item.items) {
        overallPercentage += i.averageWeight!;
      }
    }
    return overallPercentage;
  }

  double calculateOverAllScore(List<ManagementKpiSection> items) {
    double overallScore = 0.0;
    for (var item in items) {
      for (var i in item.items) {
        overallScore += i.score!;
      }
    }
    return overallScore;
  }
}
