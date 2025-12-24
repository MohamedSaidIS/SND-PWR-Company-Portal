import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../utils/export_import.dart';

class AttendLeaveScreen extends StatefulWidget {
  const AttendLeaveScreen({super.key});

  @override
  State<AttendLeaveScreen> createState() => _AttendLeaveScreenState();
}

class _AttendLeaveScreenState extends State<AttendLeaveScreen> {
  bool isLoading = true;
  bool isCheckInPressed = false;
  bool isCheckOutPressed = false;

  bool checkInAnimating = false;
  bool checkOutAnimating = false;

  String? checkInTime;
  String? checkOutTime;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => isLoading = false);
    });
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final local = context.local;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: CustomAppBar(
          title: local.attendLeaveRequest,
          backBtn: true,
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: isLoading
              ? const _AttendanceShimmer()
              : _buildMainContent(context, theme, local),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme, AppLocalizations local) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          UpFadeSlideAnimation(
            delay: 0,
            child: _statusCard(theme, local),
          ),
          const SizedBox(height: 12),
          UpFadeSlideAnimation(
            delay: 150,
            child: _actions(theme, local),
          ),
          const SizedBox(height: 12),
          UpFadeSlideAnimation(
            delay: 250,
            child: _historyCard(theme, local),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(ThemeData theme, AppLocalizations local) {
    return _animatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.todayAttendance,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
          const SizedBox(height: 12),
          _attendanceRow("${local.checkIn}:", checkInTime ?? "---", theme),
          const SizedBox(height: 8),
          _attendanceRow("${local.checkOut}:", checkOutTime ?? "---", theme),
        ],
      ),
    );
  }

  Widget _attendanceRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _actions(ThemeData theme, AppLocalizations local) {
    return Row(
      children: [
        Expanded(
          child: _animatedCard(
            child: InkWell(
              onTap: () async {
                setState(() {
                  checkInTime = _now();
                  isCheckInPressed = true;
                  checkInAnimating = true;
                });
                await Future.delayed(const Duration(milliseconds: 150));
                setState(() {
                  checkInAnimating = false;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: _actionBtn(local.checkIn, LineAwesomeIcons.sign_in_alt_solid, theme, isCheckInPressed, checkInAnimating),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _animatedCard(
            child: InkWell(
              onTap: () async {
                setState(() {
                  checkOutTime = _now();
                  isCheckOutPressed = true;
                  checkOutAnimating = true;
                });
                await Future.delayed(const Duration(milliseconds: 150));
                setState(() {
                  checkOutAnimating = false;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: _actionBtn(local.checkOut, LineAwesomeIcons.sign_out_alt_solid, theme, isCheckOutPressed, checkOutAnimating),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(String title, IconData icon, ThemeData theme, bool active, bool animating) {
    return ScaleAnimation(
      isAnimated: animating,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: active
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(ThemeData theme, AppLocalizations local) {
    return _animatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(local.attendanceHistory,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.secondary)),
          const SizedBox(height: 12),
          ...List.generate(5, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("2025-01-0${i + 1}", style: theme.textTheme.bodyLarge),
                  Text(i % 2 == 0 ? "Present" : "Leave",
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  Widget _animatedCard({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget fadeSlide({required int delay, required Widget child}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, value, __) => Opacity(
        opacity: value,
        child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)), child: child),
      ),
    );
  }

}

class _AttendanceShimmer extends StatelessWidget {
  const _AttendanceShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 20),
          ShimmerBox(),
          SizedBox(height: 20),
          ShimmerBox(),
          SizedBox(height: 20),
          ShimmerBox(),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(16)),
    );
  }
}
