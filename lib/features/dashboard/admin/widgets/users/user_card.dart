import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/user_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onTogglePause;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onTogglePause,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: user.isActive ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.formPanel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(LucideIcons.user,
                  size: 18, color: AppColors.textMuted),
            ),
            const SizedBox(width: 12),

            // ── Info ─────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.manropeLabel(
                        size: 14, weight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        user.role.label,
                        style: AppTextStyles.manropeBody(
                            size: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(isActive: user.isActive),
                    ],
                  ),
                ],
              ),
            ),

            // ── Acciones ─────────────────────────────────────────────────
            _ActionIcon(
              icon: LucideIcons.pencil,
              color: AppColors.textMuted,
              onTap: onEdit,
            ),
            const SizedBox(width: 10),
            _ActionIcon(
              icon: user.isActive
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
      ),
    );
  }

  void _confirmPause(BuildContext context) {
    final action = user.isActive ? 'pausar' : 'reactivar';
    final color = user.isActive
        ? const Color(0xFFB8860B)
        : const Color(0xFF22C55E);
    _showConfirm(
      context: context,
      icon: user.isActive ? LucideIcons.pauseCircle : LucideIcons.playCircle,
      iconColor: color,
      title: user.isActive ? 'Pausar usuario' : 'Reactivar usuario',
      message:
          '¿Deseas $action a "${user.name}"? ${user.isActive ? 'No podrá iniciar sesión.' : 'Volverá a tener acceso.'}',
      confirmLabel: user.isActive ? 'Pausar' : 'Reactivar',
      confirmColor: color,
      onConfirm: onTogglePause,
    );
  }

  void _confirmDelete(BuildContext context) {
    _showConfirm(
      context: context,
      icon: LucideIcons.trash2,
      iconColor: const Color(0xFFEF4444),
      title: 'Eliminar usuario',
      message:
          '¿Estás seguro de eliminar a "${user.name}"? Esta acción no se puede deshacer.',
      confirmLabel: 'Eliminar',
      confirmColor: const Color(0xFFEF4444),
      onConfirm: onDelete,
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Activo' : 'Inactivo',
        style: AppTextStyles.manropeLabel(
            size: 11, weight: FontWeight.w600, color: color),
      ),
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
              Text(title,
                  style: AppTextStyles.outfitHeading(
                      size: 20, weight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(message,
                  style: AppTextStyles.manropeBody(
                      size: 14, color: AppColors.textMuted),
                  textAlign: TextAlign.center),
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
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Icon(icon, size: 18, color: color),
      );
}
