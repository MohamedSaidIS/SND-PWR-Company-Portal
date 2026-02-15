import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/export_import.dart';

class SalesKpiScreen extends StatefulWidget {
  const SalesKpiScreen({
    super.key,
  });

  @override
  State<SalesKpiScreen> createState() => _SalesKpiScreenState();
}

class _SalesKpiScreenState extends State<SalesKpiScreen> {
  bool isUAT = false;
  bool isTester = false;
  bool isManager = false;
  int selectedMonth = DateTime.now().month;
  int? selectedWeek;
  late List<int> weeksPerMonth;
  GroupMember? selectedEmployee = GroupMember(memberId: "", displayName: "", givenName: "", surname: "", mail: "", jobTitle: "");

  @override
  void initState() {
    super.initState();
    weeksPerMonth = KpiCalculationHandler.getWeekNumbersInMonth(
      DateTime.now().year,
      selectedMonth,
    );
    selectedWeek = weeksPerMonth.first;

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchKpis());
  }

  Future<void> _fetchKpis({String? memberId}) async {
    final prefs = SharedPrefsHelper();
    final userId = memberId ?? await prefs.getUserData("UserId");
    final managerId = await prefs.getUserData("groupInfo");

    AppNotifier.logWithScreen("KPI Dashboard Screen",
        "Fetching KPI for UserId: $userId, isUAT: $isUAT $managerId");

    isManager = managerId == "6ca3fd12-cda4-4c3a-882d-a5da6a1e3c1b";
    isTester = getTesterIds().contains(userId);

    AppNotifier.logWithScreen(
        "KPI Dashboard Screen", "IsTaster: $isTester IsManager: $isManager");

    if (!mounted) return;
    final salesKpiProvider = context.read<SalesKPIProvider>();
    await salesKpiProvider.getSalesKpi('$userId', isUAT: isUAT);
}

  void _onMonthChanged(int month) {
    setState(() {
      selectedMonth = month;
      _rebuildWeeks();
    });
  }
  void _rebuildWeeks() {
    weeksPerMonth = KpiCalculationHandler.getWeekNumbersInMonth(
      DateTime.now().year,
      selectedMonth,
    );
    selectedWeek = weeksPerMonth.isNotEmpty ? weeksPerMonth.first : null;
  }

  void _onEmployeeChanged(GroupMember member) async {
    AppNotifier.logWithScreen("KPI Dashboard Screen", "selectedEmployee: ${member.memberId} ${member.displayName}");
    setState(() => selectedEmployee = member);
    await _fetchKpis(memberId: member.memberId);
  }

  double getAchievedValue(WeeklyKPI currentWeek, List<WeeklyKPI> weekly) {
    if (currentWeek.weekNumber != 0 ||
        selectedWeek == KpiCalculationHandler.getWeekNumber(DateTime.now())) {
      if (currentWeek.totalSales == 0.0) {
        return 0.0;
      } else {
        return currentWeek.totalSales;
      }
    } else {
      return weekly.isNotEmpty ? weekly.last.totalSales : 0.0;
    }
  }
  Future<void> _onRefresh() async {
    await _fetchKpis();

    if (!mounted) return;
    setState(() {
      selectedEmployee = GroupMember(
        memberId: "",
        displayName: "",
        givenName: "",
        surname: "",
        mail: "",
        jobTitle: "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;
    final provider = context.watch<SalesKPIProvider>();
    final kpis = provider.kpiList ?? [];
    final isLoading = provider.loading;

    final monthlyTarget = kpis.isNotEmpty ? kpis.last.monthlyTarget : 0.0;
    final daily = KpiCalculationHandler.calculateDailySales(
        kpis, selectedMonth, selectedWeek ?? 0);
    final weekly =
        KpiCalculationHandler.calculateWeeklySales(kpis, selectedMonth);
    final monthly =
        KpiCalculationHandler.calculateMonthlySales(kpis, selectedMonth);
    final currentWeek = weekly.firstWhere(
      (w) => w.weekNumber == (selectedWeek ?? 0),
      orElse: () => WeeklyKPI(weekNumber: 0, totalSales: 0, monthNumber: 0),
    );




    return Scaffold(
      appBar: CustomAppBar(title: local.kpis, backBtn: false),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            /// 🔄 Loading State
            if (isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else ...[
              /// Top Filters
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isTester) _buildUatProdButton(),
                      if (isManager)
                        EmployeeFilter(
                          selectedEmployee: selectedEmployee!,
                          onEmployeeChanged: _onEmployeeChanged,
                        ),
                      const SizedBox(height: 10),
                      MonthWeekFilter(
                        selectedMonth: selectedMonth,
                        selectedWeek: selectedWeek,
                        weeksPerMonth: weeksPerMonth,
                        onMonthChanged: _onMonthChanged,
                        onWeekChanged: (week) =>
                            setState(() => selectedWeek = week),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),

              /// 📊 KPI Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate(
                    [
                      _buildKpiCard(local.dailyKpi, daily, monthlyTarget, kpis, currentWeek),
                      _buildKpiCard(local.weeklyKpi, currentWeek.totalSales, monthlyTarget, kpis, currentWeek),
                      _buildKpiCard(local.monthlyKpi, monthly, monthlyTarget, kpis, currentWeek),
                    ],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

  }

  Widget _buildUatProdButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: isUAT
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.orange.withValues(alpha: 0.15),
          ),
          onPressed: () async {
            setState(() => isUAT = !isUAT);
            await _fetchKpis();
          },
          child: Text(isUAT ? "UAT" : "PROD"),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, double achieved, double target,
      List<SalesKPI> kpis, WeeklyKPI week) {
    return KpiPieChart(
      title: title,
      achieved: achieved,
      target: target,
      salesKpi: kpis,
      currentWeek: week,
      selectedMonth: selectedMonth,
      selectedWeek: selectedWeek,
      weeklyValues: KpiCalculationHandler.generateDays(
        KpiCalculationHandler.getIsoWeekStart(
            DateTime.now().year, selectedWeek ?? 0),
        context.local,
      ),
    );
  }
}
