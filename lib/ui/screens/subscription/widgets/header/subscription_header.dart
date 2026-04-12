import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({
    super.key,
    required this.title,
    required this.stepText,
    this.onBack,
  });

  final String title;
  final String stepText;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          onBack == null
              ? const SizedBox(width: 48)
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                  ),
                  onPressed: onBack,
                  color: Colors.black87,
                ),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              stepText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}