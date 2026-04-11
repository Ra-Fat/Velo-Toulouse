import 'package:flutter/material.dart';

class BookingTimerLoadingOverlay extends StatelessWidget {
  const BookingTimerLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        ModalBarrier(dismissible: false, color: Colors.black26),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
