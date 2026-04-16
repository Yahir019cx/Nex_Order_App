import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/product_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onTogglePause;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onTogglePause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: product.isActive ? 1.0 : 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.formPanel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Nombre + acciones ─────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.manropeLabel(
                        size: 14, weight: FontWeight.w600),
                  ),
                ),
                _ActionIcon(
                  icon: LucideIcons.pencil,
                  color: AppColors.textMuted,
                  onTap: onEdit,
                ),
                const SizedBox(width: 10),
                _ActionIcon(
                  icon: product.isActive
                      ? LucideIcons.pauseCircle
                      : LucideIcons.playCircle,
                  color: AppColors.textMuted,
                  onTap: () => _confirmPause(context),
                ),
                const SizedBox(width: 10),
                _ActionIcon(
                  icon: LucideIcons.trash2,
                  color: const Color(0xFFEF4444),
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),

            // ── Descripción ───────────────────────────────────────────────
            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                product.description,
                style: AppTextStyles.manropeBody(
                    size: 12, color: AppColors.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 10),

            // ── Precio ────────────────────────────────────────────────────
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: AppTextStyles.outfitHeading(
                  size: 20, weight: FontWeight.w700, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPause(BuildContext context) {
    final action = product.isActive ? 'pausar' : 'reactivar';
    _showConfirm(
      context: context,
      icon: product.isActive ? LucideIcons.pauseCircle : LucideIcons.playCircle,
      iconColor: const Color(0xFFB8860B),
      title: product.isActive ? 'Pausar producto' : 'Reactivar producto',
      message:
          '¿Deseas $action "${product.name}"? ${product.isActive ? 'No aparecerá disponible para agregar a órdenes.' : 'Volverá a estar disponible.'}',
      confirmLabel: product.isActive ? 'Pausar' : 'Reactivar',
      confirmColor: const Color(0xFFB8860B),
      onConfirm: onTogglePause,
    );
  }

  void _confirmDelete(BuildContext context) {
    _showConfirm(
      context: context,
      icon: LucideIcons.trash2,
      iconColor: const Color(0xFFEF4444),
      title: 'Eliminar producto',
      message:
          '¿Estás seguro de eliminar "${product.name}"? Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar',
      confirmColor: const Color(0xFFEF4444),
      onConfirm: onDelete,
    );
  }
}

// ── Confirm dialog ────────────────────────────────────────────────────────────

void _showConfirm({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String message,
  required String confirmLabel,
  required Color confirmColor,
  required VoidCallback onConfirm,
}) {
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
                  color: iconColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.outfitHeading(
                    size: 20, weight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
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
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(confirmLabel,
                          style: AppTextStyles.manropeButton(size: 16)),
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
      child: Icon(icon, size: 20, color: color),
    );
  }
}
