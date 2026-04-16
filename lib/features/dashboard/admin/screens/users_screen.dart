import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/user_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/users/user_card.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/users/user_form_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<UserModel> _users = List.of(initialMockUsers);

  List<UserModel> _byRole(UserRole role) =>
      _users.where((u) => u.role == role).toList();

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<void> _openForm({UserModel? user}) async {
    final result = await showUserFormDialog(context, user: user);
    if (result == null) return;
    setState(() {
      final idx = _users.indexWhere((u) => u.id == result.id);
      if (idx >= 0) {
        _users[idx] = result;
      } else {
        _users.add(result);
      }
    });
  }

  void _togglePause(UserModel user) {
    setState(() {
      final idx = _users.indexWhere((u) => u.id == user.id);
      if (idx >= 0) {
        _users[idx] = user.copyWith(isActive: !user.isActive);
      }
    });
  }

  void _delete(UserModel user) {
    setState(() => _users.removeWhere((u) => u.id == user.id));
  }

  // ── Layout ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final admins  = _byRole(UserRole.admin);
    final meseros = _byRole(UserRole.mesero);

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Usuarios',
                          style: AppTextStyles.outfitHeading(
                              size: 22, weight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Administra el personal del restaurante',
                          style: AppTextStyles.manropeBody(
                              size: 13, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openForm,
                  icon: const Icon(LucideIcons.plus,
                      size: 16, color: Colors.white),
                  label: Text('Agregar usuario',
                      style: AppTextStyles.manropeButton(size: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Administradores ──────────────────────────────────────────
            if (admins.isNotEmpty) ...[
              _SectionHeader(
                  label: 'Administradores', count: admins.length),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 80,
                ),
                itemCount: admins.length,
                itemBuilder: (_, i) {
                  final u = admins[i];
                  return UserCard(
                    user: u,
                    onEdit: () => _openForm(user: u),
                    onTogglePause: () => _togglePause(u),
                    onDelete: () => _delete(u),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],

            // ── Meseros ──────────────────────────────────────────────────
            if (meseros.isNotEmpty) ...[
              _SectionHeader(label: 'Meseros', count: meseros.length),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 80,
                ),
                itemCount: meseros.length,
                itemBuilder: (_, i) {
                  final u = meseros[i];
                  return UserCard(
                    user: u,
                    onEdit: () => _openForm(user: u),
                    onTogglePause: () => _togglePause(u),
                    onDelete: () => _delete(u),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: AppTextStyles.manropeLabel(
                size: 15, weight: FontWeight.w600)),
        const SizedBox(width: 8),
        Text('($count)',
            style: AppTextStyles.manropeBody(
                size: 14, color: AppColors.textMuted)),
      ],
    );
  }
}
