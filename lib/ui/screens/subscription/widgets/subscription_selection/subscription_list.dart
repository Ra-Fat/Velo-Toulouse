import 'package:flutter/material.dart';
import 'package:project/models/subscription/subscription.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_selection/plan_card.dart';
import 'package:project/utils/async_value.dart';
import 'package:project/utils/subscription_extra_data.dart';

class SubscriptionList extends StatelessWidget {
  const SubscriptionList({
    super.key,
    required this.subscriptions,
    required this.selected,
    required this.onSelect,
  });

  final AsyncValue<List<Subscription>> subscriptions;
  final Subscription? selected;
  final ValueChanged<Subscription> onSelect;

  @override
  Widget build(BuildContext context) {
    switch (subscriptions.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        final err = subscriptions.error;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Could not load subscriptions.\n${err ?? 'Unknown error'}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      case AsyncValueState.success:
        final plans = subscriptions.data ?? <Subscription>[];
        if (plans.isEmpty) {
          return const Center(child: Text('No subscriptions available.'));
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
              priceLabel: '€${plan.priceEuros.toStringAsFixed(2)}',
              description: SubscriptionExtraData.description(plan),
              promoLine: SubscriptionExtraData.promoLine(plan),
              selected: isSelected,
              onTap: () => onSelect(plan),
            );
          },
        );
    }
  }
}
