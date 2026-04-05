import 'package:flutter/material.dart';

import '../../../models/subscription_plan.dart';
import '../../app_colors.dart';
import 'widgets/step_progress.dart';
import 'widgets/plan_card.dart';

class PlanSelectionScreen extends StatelessWidget {
  const PlanSelectionScreen({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onContinue,
    this.onBackToMap,
  });

  final SubscriptionPlan selected;
  final ValueChanged<SubscriptionPlan> onSelect;
  final VoidCallback onContinue;
  final VoidCallback? onBackToMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  onBackToMap == null
                      ? const SizedBox(width: 48)
                      : IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                          ),
                          onPressed: onBackToMap,
                          color: Colors.black87,
                        ),
                  Expanded(
                    child: Text(
                      'Choose a Plan',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '1 of 2',
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: StepProgress(activeIndex: 0, steps: 2),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'Only one active pass at a time — passes are not cumulative.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: kSubscriptionPlans.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final plan = kSubscriptionPlans[i];
                  final isSelected = plan.id == selected.id;
                  return PlanCard(
                    plan: plan,
                    selected: isSelected,
                    onTap: () => onSelect(plan),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FilledButton(
                onPressed: onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

