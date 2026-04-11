import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';

class BookingTimerActions extends StatelessWidget {
  const BookingTimerActions({
    super.key,
    required this.expired,
    required this.isCancelling,
    required this.onCancel,
    required this.onDone,
  });

  final bool expired;
  final bool isCancelling;
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    if (!expired) {
      return Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: isCancelling ? null : onCancel,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: isCancelling ? null : onDone,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }

    return FilledButton(
      onPressed: isCancelling ? null : onCancel,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.grey.shade400,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
