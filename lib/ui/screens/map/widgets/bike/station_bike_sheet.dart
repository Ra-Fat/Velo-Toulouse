import 'package:flutter/material.dart';

import 'package:project/ui/screens/map/widgets/bike/bottom_sheet_header.dart';
import 'package:project/ui/widget/primary_button.dart';

import '../../../../../models/bike/bike.dart';
import '../../../../../models/station/station.dart';
import '../../../../../utils/async_value.dart';
import '../../../../theme/app_colors.dart';

import 'bike_list_section.dart';

class StationBikeSheet extends StatelessWidget {
  const StationBikeSheet({
    super.key,
    required this.station,
    required this.bikes,
    required this.selectedBikeId,
    required this.onSelectBike,
    required this.onBook,
    required this.onClose,
    required this.hasActiveBooking,
  });

  final Station station;
  final AsyncValue<List<Bike>> bikes;
  final String? selectedBikeId;
  final ValueChanged<String?> onSelectBike;
  final VoidCallback onBook;
  final VoidCallback onClose;
  final bool hasActiveBooking;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StationHeader(
              station: station,
              onClose: onClose,
            ),

            Expanded(
              child: BikeListSection(
                bikes: bikes,
                selectedBikeId: selectedBikeId,
                onSelectBike: onSelectBike,
                hasActiveBooking: hasActiveBooking,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: PrimaryButton(
                onPressed: selectedBikeId == null || hasActiveBooking ? null : onBook,
                enabled: selectedBikeId != null && !hasActiveBooking,
                child: const Text(
                  'Book',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 12),
              child: Text(
                hasActiveBooking
                    ? "* You can't book while having an active booking"
                    : "",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}