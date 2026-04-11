import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/models/booking/booking_details.dart';
import 'package:project/ui/theme/app_colors.dart';

class BookingTimerScreen extends StatefulWidget {
  const BookingTimerScreen({super.key, required this.details});

  final BookingDetails details;

  @override
  State<BookingTimerScreen> createState() => _BookingTimerScreenState();
}

class _BookingTimerScreenState extends State<BookingTimerScreen> {
  static const Duration _reservationDuration = Duration(minutes: 15);
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = _computeRemaining();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _computeRemaining() {
    final expiresAt = widget.details.booking.reservedAt.add(
      _reservationDuration,
    );
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return Duration.zero;
    return diff;
  }

  String _timeLabel(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  Future<void> _cancelRide() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expired = _remaining == Duration.zero;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
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
                    _timeLabel(_remaining),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: expired ? Colors.black54 : Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              stationName: widget.details.stationName,
              bikeNumber: widget.details.bikeNumber,
              slotLabel: widget.details.slotLabel,
            ),
            if (expired) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Text(
                  'Your reservation window ended. You can go back to the map to book another bike.',
                ),
              ),
            ],
            const Spacer(),
            if (!expired)
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _cancelRide,
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
                      onPressed: () =>
                          Navigator.of(context).popUntil((r) => r.isFirst),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              FilledButton(
                onPressed: _cancelRide,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
