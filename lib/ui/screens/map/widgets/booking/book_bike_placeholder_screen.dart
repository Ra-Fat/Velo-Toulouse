import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';


class BookBikePlaceholderScreen extends StatelessWidget {
  const BookBikePlaceholderScreen({
    super.key,
    required this.stationName,
    required this.bikeNumber,
  });

  final String stationName;
  final String bikeNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book bike'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview only (Teammate 2)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('Station: $stationName', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('Bike: #$bikeNumber', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text(
              'Booking API, reservation timer, and confirmation screens are implemented in the next task branch.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
