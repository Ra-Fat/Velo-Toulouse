import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';

class BookingTimerInfoCard extends StatelessWidget {
  const BookingTimerInfoCard({
    super.key,
    required this.stationName,
    required this.bikeNumber,
    required this.slotLabel,
  });

  final String stationName;
  final String bikeNumber;
  final String slotLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _line('Pick-up station', stationName),
          const SizedBox(height: 8),
          _line('Bike', '#$bikeNumber'),
          const SizedBox(height: 8),
          _line('Dock slot', slotLabel),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
