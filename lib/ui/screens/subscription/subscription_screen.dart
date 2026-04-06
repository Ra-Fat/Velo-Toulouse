import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/subscription/subscription_repository.dart';
import '../../../data/repositories/user_subscription/user_subscription_repository.dart';
import '../../../models/subscription/subscription.dart';
import '../../../models/user_subscription/user_subscription.dart';
import 'subscriptions_selection_screen.dart';
import 'view_model/subscription_view_model.dart';
import 'widgets/subscription_selection/active_subscription_view.dart';
import 'payment_screen.dart';

class SubscriptionFlowScreen extends StatelessWidget {
  const SubscriptionFlowScreen({super.key, this.onBackToMap});

  final VoidCallback? onBackToMap;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SubscriptionViewModel(
        subscriptionRepository: context.read<SubscriptionRepository>(),
        userSubscriptionRepository: context.read<UserSubscriptionRepository>(),
        userId: '1',
      )..load(),
      child: _SubscriptionFlowInner(onBackToMap: onBackToMap),
    );
  }
}

class _SubscriptionFlowInner extends StatefulWidget {
  const _SubscriptionFlowInner({this.onBackToMap});

  final VoidCallback? onBackToMap;

  @override
  State<_SubscriptionFlowInner> createState() => _SubscriptionFlowInnerState();
}

class _SubscriptionFlowInnerState extends State<_SubscriptionFlowInner> {
  bool _onPayment = false;

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
        onBackToMap: widget.onBackToMap,
      );
    }

    final selected = state.selected;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _onPayment && selected != null
          ? PaymentScreen(
              key: const ValueKey('payment'),
              subscription: selected,
              onBack: () => setState(() => _onPayment = false),
              onPaymentSuccess: () async {
                final repo = context.read<UserSubscriptionRepository>();
                await repo.recordSubscriptionPurchase(
                  userId: '1',
                  subscriptionId: selected.id,
                );
                if (!context.mounted) return;
                await context.read<SubscriptionViewModel>().load();
                if (!context.mounted) return;
                setState(() => _onPayment = false);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscription saved'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            )
          : SubscriptionsScreen(
              key: const ValueKey('plans'),
              onContinue: () => setState(() => _onPayment = true),
              onBackToMap: widget.onBackToMap,
            ),
    );
  }
}
