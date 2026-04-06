import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';

class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.activeIndex, required this.steps});

  final int activeIndex;
  final int steps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps, (i) {
        final filled = i <= activeIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == steps - 1 ? 0 : 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 5,
              decoration: BoxDecoration(
                color: filled ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        );
      }),
    );
  }
}
