import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KpiPieDashboard extends StatelessWidget {
  const KpiPieDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final daily = KpiSet(
      title: 'Daily KPIs',
      slices: [
        KpiSlice(label: 'Closed', value: 42, color: const Color(0xFF4CAF50)),
        KpiSlice(label: 'In Progress', value: 28, color: const Color(0xFFFFC107)),
        KpiSlice(label: 'Pending', value: 15, color: const Color(0xFF2196F3)),
        KpiSlice(label: 'Overdue', value: 6, color: const Color(0xFFF44336)),
      ],
    );

    final weekly = KpiSet(
      title: 'Weekly KPIs',
      slices: [
        KpiSlice(label: 'Closed', value: 210, color: const Color(0xFF4CAF50)),
        KpiSlice(label: 'In Progress', value: 105, color: const Color(0xFFFFC107)),
        KpiSlice(label: 'Pending', value: 58, color: const Color(0xFF2196F3)),
        KpiSlice(label: 'Overdue', value: 18, color: const Color(0xFFF44336)),
      ],
    );

    final monthly = KpiSet(
      title: 'Monthly KPIs',
      slices: [
        KpiSlice(label: 'Closed', value: 820, color: const Color(0xFF4CAF50)),
        KpiSlice(label: 'In Progress', value: 290, color: const Color(0xFFFFC107)),
        KpiSlice(label: 'Pending', value: 165, color: const Color(0xFF2196F3)),
        KpiSlice(label: 'Overdue', value: 44, color: const Color(0xFFF44336)),
      ],
    );

    final items = [daily, weekly, monthly];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('KPIs Overview'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final isMedium = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
          final crossAxisCount = isWide ? 3 : (isMedium ? 2 : 1);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _KpiPieCard(set: items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _KpiPieCard extends StatefulWidget {
  const _KpiPieCard({required this.set});
  final KpiSet set;

  @override
  State<_KpiPieCard> createState() => _KpiPieCardState();
}

class _KpiPieCardState extends State<_KpiPieCard> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.set.total;

    return InkWell(
      onTap: () => setState(() => _touchedIndex = null),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity, // take full width of grid cell
          height: 200, // fixed height (you can tweak this)
          child: PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    setState(() => _touchedIndex = null);
                    return;
                  }
                  setState(() => _touchedIndex =
                      response.touchedSection!.touchedSectionIndex);
                },
              ),
              sections: [
                for (int i = 0; i < widget.set.slices.length; i++)
                  _buildSection(
                    index: i,
                    slice: widget.set.slices[i],
                    total: total,
                    isTouched: _touchedIndex == i,
                    context: context,
                  ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }

  PieChartSectionData _buildSection({
    required int index,
    required KpiSlice slice,
    required double total,
    required bool isTouched,
    required BuildContext context,
  }) {
    final percent = total == 0 ? 0.0 : (slice.value / total * 100);
    final radius = isTouched ? 78.0 : 68.0;
    final title = percent >= 6 ? '${percent.toStringAsFixed(0)}%' : '';
    return PieChartSectionData(
      color: slice.color,
      value: slice.value,
      radius: radius,
      title: title,
      titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titlePositionPercentageOffset: 0.6,
      badgeWidget: isTouched ? _SliceBadge(label: slice.label) : null,
      badgePositionPercentageOffset: 1.25,
    );
  }
}

class _SliceBadge extends StatelessWidget {
  const _SliceBadge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}



class KpiSet {
  final String title;
  final List<KpiSlice> slices;
  KpiSet({required this.title, required this.slices});
  double get total => slices.fold(0, (p, c) => p + c.value);
}

class KpiSlice {
  final String label;
  final double value;
  final Color color;
  KpiSlice({required this.label, required this.value, required this.color});
}
