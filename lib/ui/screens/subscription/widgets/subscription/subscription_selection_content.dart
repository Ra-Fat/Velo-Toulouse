import 'package:flutter/material.dart';
import 'package:project/ui/screens/subscription/widgets/header/subscription_header.dart';
import 'package:project/ui/screens/subscription/widgets/header/step_progress.dart';
import 'package:provider/provider.dart';
import 'package:project/ui/widget/primary_button.dart';
import '../../../../theme/app_colors.dart';
import '../../view_model/subscription_view_model.dart';
import 'subscription_list.dart';

class SubscriptionSelectionContent extends StatelessWidget {
  const SubscriptionSelectionContent({
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
            SubscriptionHeader(
              title: 'Choose a Plan',
              stepText: '1 of 2',
              onBack: onBackToMap,
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
              child: SubscriptionList(
                subscriptions: state.catalog,
                selected: state.selected,
                onSelect: vm.select,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PrimaryButton(
                onPressed: state.selected == null ? null : onContinue,
                enabled: state.selected != null,
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