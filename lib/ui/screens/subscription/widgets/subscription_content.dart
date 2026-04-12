import 'package:flutter/material.dart';
import 'package:project/ui/screens/subscription/widgets/payment_content.dart';
import 'package:project/ui/screens/subscription/widgets/subscription/active_subscription_view.dart';
import 'package:project/ui/screens/subscription/widgets/subscription/subscription_selection_content.dart';
import 'package:provider/provider.dart';

import '../../../../services/app_session.dart';
import '../../../../../data/repositories/user_subscription/user_subscription_repository.dart';
import '../../../../../models/subscription/subscription.dart';
import '../view_model/subscription_view_model.dart';

class SubscriptionContent extends StatelessWidget {
  const SubscriptionContent({super.key, this.onBackToMap});

  final VoidCallback? onBackToMap;

  VoidCallback _buildOnContinue(BuildContext context, Subscription? selected) {
    if (selected == null) return () {};

    return () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (paymentContext) => PaymentScreen(
            subscription: selected,
            onBack: () => Navigator.of(paymentContext).pop(),
            onPaymentSuccess: () async {
              final repo = context.read<UserSubscriptionRepository>();

              await repo.recordSubscriptionPurchase(
                userId: AppSession.userId,
                subscriptionId: selected.id,
              );

              await context.read<SubscriptionViewModel>().load();

              if (!context.mounted) return;

              Navigator.of(paymentContext).pop();
              onBackToMap?.call();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription saved')),
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
      return Center(
        child: FilledButton(
          onPressed: vm.load,
          child: const Text('Retry'),
        ),
      );
    }

    if (state.hasActivePass) {
      return ActiveSubscriptionView(
        pass: state.activeSubscription.data!,
        catalog: state.catalog.data ?? [],
        onBackToMap: onBackToMap,
      );
    }

    return SubscriptionSelectionContent(
      onContinue: _buildOnContinue(context, state.selected),
      onBackToMap: onBackToMap,
    );
  }
}