import 'package:flutter/material.dart';
import 'package:project/ui/screens/subscription/payment_screen.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_selection/active_subscription_view.dart';
import 'package:project/ui/screens/subscription/widgets/subscription_selection/subscription_selection_content.dart';
import 'package:provider/provider.dart';

import '../../../../models/subscription/subscription.dart';
import '../../../../models/user_subscription/user_subscription.dart';
import 'view_model/subscription_view_model.dart';

class SubscriptionSelectionScreen extends StatelessWidget {
  const SubscriptionSelectionScreen({super.key, this.onBackToMap});

  final VoidCallback? onBackToMap;

  VoidCallback _buildOnContinue(
    BuildContext context,
    SubscriptionViewModel vm,
    Subscription? selected,
  ) {
    if (selected == null) return () {};

    return () {
      final picked = selected;
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (paymentContext) => PaymentScreen(
            subscription: picked,
            onBack: () => Navigator.of(paymentContext).pop(),
            onPaymentSuccess: () async {
              await vm.completePurchaseAfterPayment(picked);
              if (!context.mounted) return;
              Navigator.of(paymentContext).pop();
              onBackToMap?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subscription saved'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SubscriptionViewModel>();
    final state = vm.state;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      final err = state.catalog.error ?? state.activeSubscription.error;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Could not load subscription data.\n${err ?? 'Unknown error'}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => vm.load(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.hasActivePass) {
      final UserSubscription pass = state.activeSubscription.data!;
      final catalog = state.catalog.data ?? <Subscription>[];
      return ActiveSubscriptionView(
        key: const ValueKey('active'),
        pass: pass,
        catalog: List.of(catalog),
        onBackToMap: onBackToMap,
      );
    }

    return SubscriptionSelectionContent(
      key: const ValueKey('plans'),
      onContinue: _buildOnContinue(context, vm, state.selected),
      onBackToMap: onBackToMap,
    );
  }
}
