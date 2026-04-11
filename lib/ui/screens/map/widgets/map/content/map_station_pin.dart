import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class MapStationPin extends StatelessWidget {
  const MapStationPin({
    super.key,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = AppColors.primary;
    if (selected) {
      backgroundColor = AppColors.primaryDark;
    } else if (count > 0) {
      backgroundColor = AppColors.primary;
    } else {
      backgroundColor = AppColors.textSecondary;
    }
    return GestureDetector(
      onTap: count > 0 ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
