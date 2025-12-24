import 'package:flutter/material.dart';
import 'package:company_portal/utils/export_import.dart';

class StateHandlerWidget extends StatelessWidget {
  final ViewState state;
  final String? error;
  final String emptyTitle;
  final String emptySubtitle;

  final WidgetBuilder? emptyBuilder;
  final WidgetBuilder? dataBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? errorBuilder;

  const StateHandlerWidget({
    super.key,
    required this.state,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.error,
    this.emptyBuilder,
    this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (state) {
      case ViewState.loading:
        return loadingBuilder?.call(context) ?? AppNotifier.loadingWidget(context.theme);

      case ViewState.error:
        return errorBuilder?.call(context) ?? _ErrorView(error: error ?? "حدث خطأ غير متوقع");

      case ViewState.empty:
        return emptyBuilder?.call(context) ?? _DefaultEmptyView(title: emptyTitle, subtitle: emptySubtitle,);

      case ViewState.data:
        return dataBuilder?.call(context) ?? const SizedBox.shrink();
    }
  }
}


class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
            const SizedBox(height: 16),
            Text(
              "حدث خطأ",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(color: Colors.redAccent),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultEmptyView extends StatelessWidget {
  final String title, subtitle;

  const _DefaultEmptyView({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      key: const ValueKey('empty'),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              child: Image.asset(
                "assets/images/no_team_member.png",
                cacheHeight: 200,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
