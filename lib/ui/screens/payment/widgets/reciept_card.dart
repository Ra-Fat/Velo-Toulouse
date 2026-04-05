import 'package:flutter/material.dart';
import 'package:project/models/subscription_plan.dart';
import 'package:project/ui/app_colors.dart';
import 'package:project/ui/screens/payment/widgets/reciept_row.dart';

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    required this.plan,
    required this.starts,
    required this.expires,
    required this.renews,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
  });

  final SubscriptionPlan plan;
  final String starts;
  final String expires;
  final String renews;
  final double subtotal;
  final double serviceFee;
  final double total;

  String _money(double v) {
    if (v == v.roundToDouble()) return '€${v.toStringAsFixed(2)}';
    return '€${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.directions_bike_rounded,
                    color: AppColors.surfaceMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscription summary',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.surfaceMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        plan.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.surfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              children: [
                ReceiptRow(label: 'Plan', value: plan.title),
                const SizedBox(height: 10),
                ReceiptRow(label: 'Starts', value: starts),
                const SizedBox(height: 10),
                ReceiptRow(label: 'Expires', value: expires),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: AppColors.border.withValues(alpha: 0.9),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Total due',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  _money(total),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
