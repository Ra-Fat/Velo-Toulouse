import 'package:flutter/material.dart';
import 'package:project/ui/screens/payment/widgets/reciept_card.dart';
import 'package:project/ui/screens/subscription/widgets/step_progress.dart';

import '../../../models/subscription_plan.dart';
import '../../app_colors.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.plan, required this.onBack});

  final SubscriptionPlan plan;
  final VoidCallback onBack;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = _staticSchedule(widget.plan);
    final subtotal = widget.plan.priceEuros;
    const serviceFee = 0.0;
    final total = subtotal + serviceFee;

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    onPressed: widget.onBack,
                    color: Colors.black87,
                  ),
                  Expanded(
                    child: Text(
                      'Payment',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '2 of 2',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: StepProgress(activeIndex: 1, steps: 2),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    'Review and pay. You can only hold one active pass; buying a new one replaces the current pass.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ReceiptCard(
                    plan: widget.plan,
                    starts: dates.$1,
                    expires: dates.$2,
                    renews: dates.$3,
                    subtotal: subtotal,
                    serviceFee: serviceFee,
                    total: total,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Pay ${widget.plan.priceLabel} (static demo)',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Pay ${widget.plan.priceLabel}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Static copy for the demo (aligned with “today” = 5 Apr 2026).
  (String, String, String) _staticSchedule(SubscriptionPlan p) {
    switch (p.id) {
      case 'day':
        return ('5 Apr 2026', '6 Apr 2026', 'Does not renew');
      case 'monthly':
        return ('5 Apr 2026', '5 May 2026', 'Monthly — cancel anytime');
      case 'annual':
        return ('5 Apr 2026', '5 Apr 2027', 'Yearly — cancel anytime');
      default:
        return ('', '', '');
    }
  }
}
