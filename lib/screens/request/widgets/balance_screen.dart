import 'dart:core';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../utils/export_import.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VacationBalanceProvider>();
    final balance = provider.vacationBalance;
    final local = context.local;
    final theme = context.theme;

    return balance?.currentBalance == 0
        ? noDataExist(local.noLeaveBalance, theme)
        : (provider.loading || balance == null)
            ? loadingWidget(theme)
            : SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.43,
                ),
                delegate: SliverChildListDelegate(
                  [
                    BalanceCard(
                      title: local.balance,
                      amount: balance.currentBalance.toInt().toString(),
                      icon: LineAwesomeIcons.calendar,
                    ),
                    BalanceCard(
                      title: local.remain,
                      remainAmount: balance.remain.toInt().toString(),
                      amount: balance.currentBalance.toInt().toString(),
                      isRemain: true,
                      icon: LineAwesomeIcons.history_solid,
                    ),
                    BalanceCard(
                      title: local.consumedDays,
                      amount: balance.consumedDays.toString(),
                      icon: LineAwesomeIcons.check_circle_solid,
                    ),
                  ],
                ),
              );
  }
}

class BalanceCard extends StatelessWidget {
  final String title;
  final String remainAmount;
  final String amount;
  final IconData icon;
  final bool isRemain;

  const BalanceCard(
      {required this.title,
      this.remainAmount = "",
      this.amount = "",
      required this.icon,
      this.isRemain = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isArabic = context.isArabic();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.secondary.withValues(alpha: 0.15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 2,
                children: [
                  Icon(
                    icon,
                    color: Colors.black,
                    size: 20,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: isRemain
                    ? Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: convertedToArabicNumber(
                                  remainAmount, isArabic),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: "/",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            TextSpan(
                              text: convertedToArabicNumber(amount, isArabic),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: theme.colorScheme.secondary,
                              ),
                            )
                          ],
                        ),
                      )
                    : Text(
                        convertedToArabicNumber(amount, isArabic),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
