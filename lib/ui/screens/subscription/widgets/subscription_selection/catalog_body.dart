import 'package:flutter/material.dart';
import 'package:project/models/subscription/subscription.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_copy.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_selection/plan_card.dart';
import 'package:project/ui/utils/async_value.dart';

class CatalogBody extends StatelessWidget {
  const CatalogBody({
    super.key,
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

String _euroPriceLabel(double euros) {
  if (euros == euros.roundToDouble()) {
    return '€${euros.toStringAsFixed(0)}';
  }
  return '€${euros.toStringAsFixed(2)}';
}
