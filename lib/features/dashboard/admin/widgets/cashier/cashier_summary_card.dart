import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class CashierSummaryCard extends StatelessWidget {
  final double totalVentas;
  final int accountCount;
  final double totalCash;
  final double totalCard;
  final bool showDesglose;
  final VoidCallback onToggleDesglose;

  const CashierSummaryCard({
    super.key,
    required this.totalVentas,
    required this.accountCount,
    required this.totalCash,
    required this.totalCard,
    required this.showDesglose,
    required this.onToggleDesglose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.formPanel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.fromLTRB(28, 22, 24, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Total ────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ventas del día',
                    style: AppTextStyles.manropeBody(
                        size: 13, color: AppColors.textMuted)),
                const SizedBox(height: 6),
                Text(
                  '\$${totalVentas.toStringAsFixed(2)}',
                  style: AppTextStyles.outfitHeading(
                      size: 34,
                      weight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '$accountCount cuenta${accountCount == 1 ? '' : 's'} cerrada${accountCount == 1 ? '' : 's'}',
                  style: AppTextStyles.manropeBody(
                      size: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // ── Desglose (animado) ────────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: showDesglose && accountCount > 0
                ? Row(
                    children: [
                      Container(
                          width: 1, height: 64, color: AppColors.border),
                      const SizedBox(width: 28),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatItem(
                            icon: LucideIcons.banknote,
                            label: 'Efectivo',
                            amount: totalCash,
                            color: const Color(0xFF22C55E),
                          ),
                          const SizedBox(height: 14),
                          _StatItem(
                            icon: LucideIcons.creditCard,
                            label: 'Tarjeta',
                            amount: totalCard,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                      const SizedBox(width: 28),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          // ── Toggle ────────────────────────────────────────────────────
          GestureDetector(
            onTap: onToggleDesglose,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                showDesglose ? 'Ocultar desglose' : 'Ver desglose',
                style: AppTextStyles.manropeLabel(
                    size: 13, color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat item ─────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  // color kept for API compat but no longer used visually
  final Color color;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 16, color: AppColors.textMuted),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: AppTextStyles.manropeBody(
                    size: 11, color: AppColors.textMuted)),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: AppTextStyles.manropeLabel(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
