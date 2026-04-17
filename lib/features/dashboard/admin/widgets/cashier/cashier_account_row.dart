import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/cashier_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'cashier_date_utils.dart';

class CashierAccountRow extends StatelessWidget {
  final ClosedAccount account;
  const CashierAccountRow({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final parts = account.total.toStringAsFixed(2).split('.');
    final intPart  = parts[0];
    final decPart  = parts[1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.formPanel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // ── Icono ─────────────────────────────────────────────────────
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(LucideIcons.receipt,
                size: 18, color: AppColors.textMuted),
          ),
          const SizedBox(width: 16),

          // ── Info ──────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(account.tableName,
                        style: AppTextStyles.manropeLabel(
                            size: 14, weight: FontWeight.w600)),
                    const SizedBox(width: 10),
                    _ClosedBadge(),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${fmtDate(account.closedAt)}  •  ${fmtTime(account.closedAt)}',
                  style: AppTextStyles.manropeBody(
                      size: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),

          // ── Total ─────────────────────────────────────────────────────
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '\$',
                style: AppTextStyles.outfitHeading(
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColors.textPrimary),
              ),
              TextSpan(
                text: intPart,
                style: AppTextStyles.outfitHeading(
                    size: 19,
                    weight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              TextSpan(
                text: '.$decPart',
                style: AppTextStyles.outfitHeading(
                    size: 14,
                    weight: FontWeight.w500,
                    color: AppColors.textPrimary),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────

class _ClosedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Cerrada',
        style: AppTextStyles.manropeLabel(
            size: 11,
            weight: FontWeight.w600,
            color: const Color(0xFF22C55E)),
      ),
    );
  }
}
