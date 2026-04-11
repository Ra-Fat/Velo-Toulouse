import 'package:flutter/material.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_copy.dart';
import 'package:provider/provider.dart';

import '../../../models/subscription/subscription.dart';
import '../../theme/app_colors.dart';
import '../../../utils/async_value.dart';
import 'view_model/subscription_view_model.dart';
import 'widgets/subscription_selection/plan_card.dart';
import 'widgets/step_progress.dart';

String _euroPriceLabel(double euros) {
  if (euros == euros.roundToDouble()) {
    return '€${euros.toStringAsFixed(0)}';
  }
  return '€${euros.toStringAsFixed(2)}';
}

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({
    super.key,
    required this.onContinue,
    this.onBackToMap,
  });

  final VoidCallback onContinue;
  final VoidCallback? onBackToMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<SubscriptionViewModel>();
    final state = vm.state;

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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
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
              child: _CatalogBody(
                catalog: state.catalog,
                selected: state.selected,
                onSelect: vm.select,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: FilledButton(
                onPressed: state.selected == null ? null : onContinue,
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

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.catalog,
    required this.selected,
    required this.onSelect,
  });

  final AsyncValue<List<Subscription>> catalog;
  final Subscription? selected;
  final ValueChanged<Subscription> onSelect;

  @override
  Widget build(BuildContext context) {
    switch (catalog.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        final err = catalog.error;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Could not load plans.\n${err ?? 'Unknown error'}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case AsyncValueState.success:
        final plans = catalog.data ?? <Subscription>[];
        if (plans.isEmpty) {
          return const Center(child: Text('No plans available.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: plans.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final plan = plans[i];
            final isSelected = selected?.id == plan.id;
            return PlanCard(
              title: plan.name,
              priceLabel: _euroPriceLabel(plan.priceEuros),
              description: SubscriptionCopy.description(plan),
              promoLine: SubscriptionCopy.promoLine(plan),
              selected: isSelected,
              onTap: () => onSelect(plan),
            );
          },
        );
    }
  }
}
