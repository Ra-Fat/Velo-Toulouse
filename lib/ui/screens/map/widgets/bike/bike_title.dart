import 'package:flutter/material.dart';

import '../../../../../models/bike/bike.dart';
import '../../../../theme/app_colors.dart';

class BikeTile extends StatelessWidget {
  const BikeTile({
    super.key,
    required this.bike,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final Bike bike;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bike #${bike.number}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text('At this station'),
                  ],
                ),
              ),
              Icon(
                Icons.directions_bike,
                color: AppColors.primary,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}