import 'package:flutter/material.dart';
import 'package:project/utils/plan_duration.dart';

import '../../../models/subscription/subscription.dart';
import '../../theme/app_colors.dart';
import '../subscription/widgets/payment/reciept_card.dart';
import '../subscription/widgets/step_progress.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.subscription,
    required this.onBack,
  });

  final Subscription subscription;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dates = planDuration(subscription);
    final subtotal = subscription.priceEuros;
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
                    onPressed: onBack,
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
            const Padding(
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
                    subscription: subscription,
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
                        'Pay ${subscription.priceEuros} (static demo)',
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
                  'Pay ${subscription.priceEuros}',
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
}
