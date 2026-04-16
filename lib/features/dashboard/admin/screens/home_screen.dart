import 'package:flutter/material.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 56,
              color: AppColors.accent.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 20),
            Text(
              'En desarrollo',
              style: AppTextStyles.outfitHeading(
                size: 28,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta sección estará disponible pronto.',
              style: AppTextStyles.manropeBody(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
