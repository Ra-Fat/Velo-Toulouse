import 'package:flutter/material.dart';

import '../../../models/subscription_plan.dart';
import 'plan_selection_screen.dart';
import '../payment/payment_page.dart';

class SubscriptionFlowScreen extends StatefulWidget {
  const SubscriptionFlowScreen({super.key, this.onBackToMap});
  final VoidCallback? onBackToMap;

  @override
  State<SubscriptionFlowScreen> createState() => _SubscriptionFlowScreenState();
}

class _SubscriptionFlowScreenState extends State<SubscriptionFlowScreen> {
  bool _onPayment = false;
  late SubscriptionPlan _selected;

  @override
  void initState() {
    super.initState();
    _selected = planById('monthly');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _onPayment
          ? PaymentPage(
              key: const ValueKey('payment'),
              plan: _selected,
              onBack: () => setState(() => _onPayment = false),
            )
          : PlanSelectionScreen(
              key: const ValueKey('plans'),
              selected: _selected,
              onSelect: (p) => setState(() => _selected = p),
              onContinue: () => setState(() => _onPayment = true),
              onBackToMap: widget.onBackToMap,
            ),
    );
  }
}
