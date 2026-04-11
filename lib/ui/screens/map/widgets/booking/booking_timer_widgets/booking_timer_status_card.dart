import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';

class BookingTimerStatusCard extends StatelessWidget {
  const BookingTimerStatusCard({
    super.key,
    required this.expired,
    required this.timeLabel,
  });

  final bool expired;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: expired ? Colors.black12 : AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            expired ? 'Reservation expired' : 'Reservation expires in',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: expired ? Colors.black54 : Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            timeLabel,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: expired ? Colors.black54 : Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
