import 'package:flutter/material.dart';

import 'package:project/ui/theme/app_colors.dart';
import 'package:project/ui/widget/primary_button.dart';

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
            child: PrimaryButton(
              onPressed: isCancelling ? null : onCancel,
              enabled: !isCancelling,
              backgroundColor: Colors.grey,
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
            child: PrimaryButton(
              onPressed: isCancelling ? null : onDone,
              enabled: !isCancelling,
              child: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        ],
      );
    }

    return PrimaryButton(
      onPressed: isCancelling ? null : onCancel,
      enabled: !isCancelling,
      backgroundColor: Colors.grey,
      child: const Text(
        'Cancel',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}
