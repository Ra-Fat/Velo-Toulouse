import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/subscription/subscription_repository.dart';
import '../../../data/repositories/user_subscription/user_subscription_repository.dart';
import 'view_model/subscription_view_model.dart';
import 'widgets/subscription_screen_content.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key, this.onBackToMap});

  final VoidCallback? onBackToMap;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SubscriptionViewModel(
        subscriptionRepository: context.read<SubscriptionRepository>(),
        userSubscriptionRepository: context.read<UserSubscriptionRepository>(),
        userId: '1',
      )..load(),
      child: SubscriptionScreenContent(onBackToMap: onBackToMap),
    );
  }
}
