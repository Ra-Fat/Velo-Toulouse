import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/models/booking/booking_details.dart';
import 'package:project/ui/screens/map/view_model/booking_view_model.dart';
import 'package:provider/provider.dart';

import 'booking_timer_widgets/booking_timer_actions.dart';
import 'booking_timer_widgets/booking_timer_info_card.dart';
import 'booking_timer_widgets/booking_timer_loading_overlay.dart';
import 'booking_timer_widgets/booking_timer_status_card.dart';

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

  Future<void> _cancelRide(BookingViewModel viewModel) async {
    if (viewModel.state.isCreating) return;
    final ok = await viewModel.cancelBooking(widget.details.booking.id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not cancel booking')));
      return;
    }
    Navigator.of(context).popUntil((r) => r.isFirst);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    final viewModel = context.watch<BookingViewModel>();
    final isCancelling = viewModel.state.isCreating;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My booking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BookingTimerStatusCard(
                  expired: expired,
                  timeLabel: _timeLabel(_remaining),
                ),
                const SizedBox(height: 16),
                BookingTimerInfoCard(
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
                BookingTimerActions(
                  expired: expired,
                  isCancelling: isCancelling,
                  onCancel: () => _cancelRide(viewModel),
                  onDone: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              ],
            ),
          ),
          if (isCancelling) const BookingTimerLoadingOverlay(),
        ],
      ),
    );
  }
}
