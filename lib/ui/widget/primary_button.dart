import 'package:flutter/material.dart';
import 'package:project/ui/theme/app_colors.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderRadius = 14,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: child,
    );
  }
}
