import 'package:flutter/material.dart';
import 'package:project/ui/app_colors.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      top: 8,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(14),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Search a station…',
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
