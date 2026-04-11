import 'package:flutter/material.dart';

import '../../../../../models/subscription/subscription.dart';
import '../../../../../models/user_subscription/user_subscription.dart';
import '../../../../theme/app_colors.dart';

import '../../../../../utils/format_date.dart';

String _planTitle(UserSubscription pass, List<Subscription> catalog) {
  for (final s in catalog) {
    if (s.id == pass.subscriptionId) return s.name;
  }
  return pass.subscriptionId;
}

class ActiveSubscriptionView extends StatelessWidget {
  const ActiveSubscriptionView({
    super.key,
    required this.pass,
    required this.catalog,
    this.onBackToMap,
  });

  final UserSubscription pass;
  final List<Subscription> catalog;
  final VoidCallback? onBackToMap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _planTitle(pass, catalog);

    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        'Subscription',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current subscription',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Renews or ends on ${formatDate(pass.expiresAt)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Only one active pass at a time. When it expires, you can choose a new plan here.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
