import 'package:flutter/material.dart';

import 'ui/app_colors.dart';
import 'ui/shell/home_shell.dart';

void main() {
  runApp(const VeloToulouseApp());
}

class VeloToulouseApp extends StatelessWidget {
  const VeloToulouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Velo Toulouse',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: Colors.white,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            );
          }),
        ),
      ),
      home: const HomeShell(),
    );
  }
}
