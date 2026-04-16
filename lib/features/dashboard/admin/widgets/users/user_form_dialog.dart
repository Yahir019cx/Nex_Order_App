import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/user_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

Future<UserModel?> showUserFormDialog(
  BuildContext context, {
  UserModel? user,
}) {
  return showGeneralDialog<UserModel>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => UserFormDialog(user: user),
    transitionBuilder: (_, anim, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
  );
}

class UserFormDialog extends StatefulWidget {
  final UserModel? user;
  const UserFormDialog({super.key, this.user});

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _password;
  late UserRole? _role;
  bool _obscure = true;

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    _name     = TextEditingController(text: widget.user?.name ?? '');
    _password = TextEditingController();
    _role     = widget.user?.role;
  }

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  void _generatePassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$';
    final rng = Random.secure();
    final pwd =
        List.generate(12, (_) => chars[rng.nextInt(chars.length)]).join();
    setState(() {
      _password.text = pwd;
      _obscure = false;
    });
  }

  void _save() {
    final name = _name.text.trim();
    if (name.isEmpty || _role == null) return;
    if (!_isEdit && _password.text.trim().isEmpty) return;

    final result = widget.user?.copyWith(name: name, role: _role) ??
        UserModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          role: _role!,
        );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Blur backdrop ───────────────────────────────────────────────
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child:
                Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
        ),

        // ── Card ────────────────────────────────────────────────────────
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 520,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C1A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEdit ? 'Editar usuario' : 'Nuevo usuario',
                          style: AppTextStyles.outfitHeading(
                              size: 20, weight: FontWeight.w600),
                        ),
                      ),
                      _CloseBtn(
                          onTap: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nombre
                  _FieldLabel('Nombre completo'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: _name,
                    hint: 'Ej: Juan Pérez',
                    autofocus: true,
                  ),
                  const SizedBox(height: 18),

                  // Rol
                  _FieldLabel('Rol'),
                  const SizedBox(height: 8),
                  _RoleDropdown(
                    value: _role,
                    onChanged: (v) => setState(() => _role = v),
                  ),
                  const SizedBox(height: 18),

                  // Contraseña
                  Row(
                    children: [
                      _FieldLabel('Contraseña'),
                      if (_isEdit) ...[
                        const SizedBox(width: 6),
                        Text('(dejar vacío para no cambiar)',
                            style: AppTextStyles.manropeBody(
                                size: 12, color: AppColors.textMuted)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _passwordField(),
                  const SizedBox(height: 28),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CancelBtn(
                          onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      _SaveBtn(onTap: _save),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: AppTextStyles.manropeBody(
          size: 14, color: AppColors.textPrimary),
      cursorColor: AppColors.accent,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _password,
      obscureText: _obscure,
      style: AppTextStyles.manropeBody(
          size: 14, color: AppColors.textPrimary),
      cursorColor: AppColors.accent,
      decoration: _inputDecoration('Ingresa contraseña').copyWith(
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _generatePassword,
              child: const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(LucideIcons.refreshCw,
                    size: 16, color: AppColors.textMuted),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                  _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.manropeHint(size: 14),
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      );
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.manropeLabel(
            size: 13, color: AppColors.textMuted),
      );
}

class _RoleDropdown extends StatelessWidget {
  final UserRole? value;
  final ValueChanged<UserRole?> onChanged;

  const _RoleDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserRole>(
          value: value,
          hint: Text('Seleccionar rol',
              style: AppTextStyles.manropeHint(size: 14)),
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1C1A),
          icon: const Icon(LucideIcons.chevronDown,
              size: 16, color: AppColors.textMuted),
          style: AppTextStyles.manropeBody(
              size: 14, color: AppColors.textPrimary),
          items: UserRole.values
              .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _CloseBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(LucideIcons.x,
              size: 14, color: AppColors.textMuted),
        ),
      );
}

class _CancelBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _CancelBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.inputFill,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        ),
        child: Text('Cancelar',
            style: AppTextStyles.manropeButton(
                size: 14, color: AppColors.textMuted)),
      );
}

class _SaveBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _SaveBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        ),
        child: Text('Guardar',
            style: AppTextStyles.manropeButton(size: 15)),
      );
}
