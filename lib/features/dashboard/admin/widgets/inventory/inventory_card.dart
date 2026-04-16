import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/inventory_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const InventoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.formPanel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isLowStock
              ? const Color(0xFFB8860B).withValues(alpha: 0.5)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Nombre + acciones ───────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: AppTextStyles.manropeLabel(
                      size: 14, weight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _ActionIcon(
                icon: LucideIcons.pencil,
                color: AppColors.textMuted,
                onTap: onEdit,
              ),
              const SizedBox(width: 10),
              _ActionIcon(
                icon: LucideIcons.trash2,
                color: const Color(0xFFEF4444),
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),

          // ── Badge stock bajo ────────────────────────────────────────────
          if (item.isLowStock) ...[
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFB8860B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Stock bajo',
                style: AppTextStyles.manropeLabel(
                    size: 11,
                    weight: FontWeight.w600,
                    color: const Color(0xFFB8860B)),
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(color: Color(0xFF3A3735), height: 1, thickness: 1),
          const SizedBox(height: 8),

          // ── Cantidad ────────────────────────────────────────────────────
          Text(
            'Cantidad disponible',
            style: AppTextStyles.manropeBody(
                size: 11, color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${item.quantity}',
                        style: AppTextStyles.outfitHeading(
                            size: 22,
                            weight: FontWeight.w700,
                            color: item.isLowStock
                                ? const Color(0xFFB8860B)
                                : AppColors.textPrimary),
                      ),
                      TextSpan(
                        text: '  ${item.unit}',
                        style: AppTextStyles.manropeBody(
                            size: 13, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              // +/- controls
              _QtyButton(
                icon: LucideIcons.minus,
                onTap: item.quantity > 0 ? onDecrement : null,
              ),
              const SizedBox(width: 8),
              _QtyButton(
                icon: LucideIcons.plus,
                onTap: onIncrement,
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1E1C1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 520,
          child: Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.trash2,
                      size: 28, color: Color(0xFFEF4444)),
                ),
                const SizedBox(height: 20),
                Text(
                  'Eliminar artículo',
                  style: AppTextStyles.outfitHeading(
                      size: 20, weight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '¿Estás seguro de eliminar "${item.name}"? Esta acción no se puede deshacer.',
                  style: AppTextStyles.manropeBody(
                      size: 14, color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.inputFill,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: Text('Cancelar',
                            style: AppTextStyles.manropeButton(
                                size: 16, color: AppColors.textMuted)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDelete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        child: Text('Eliminar',
                            style:
                                AppTextStyles.manropeButton(size: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.inputFill.withValues(alpha: 0.5)
              : filled
                  ? AppColors.accent
                  : AppColors.inputFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: disabled
                ? AppColors.border.withValues(alpha: 0.4)
                : filled
                    ? AppColors.accent
                    : AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: disabled
              ? AppColors.textMuted.withValues(alpha: 0.3)
              : filled
                  ? Colors.white
                  : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionIcon(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 18, color: color),
    );
  }
}
