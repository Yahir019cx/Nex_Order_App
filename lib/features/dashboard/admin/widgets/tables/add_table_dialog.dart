import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

/// Muestra el dialog con overlay blur. Usar en lugar de showDialog.
Future<Map<String, dynamic>?> showAddTableDialog(BuildContext context) {
  return showGeneralDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => const AddTableDialog(),
    transitionBuilder: (_, anim, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

class AddTableDialog extends StatefulWidget {
  const AddTableDialog({super.key});

  @override
  State<AddTableDialog> createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<AddTableDialog> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _nameFocus = FocusNode();
  final _numberFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _nameFocus.dispose();
    _numberFocus.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();
    if (name.isEmpty || number.isEmpty) return;
    Navigator.of(context).pop({'name': name, 'number': int.tryParse(number)});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Blur backdrop ────────────────────────────────────────────────────
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
        ),

        // ── Dialog card ──────────────────────────────────────────────────────
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 560,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1C1A),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(44),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Agregar mesa',
                          style: AppTextStyles.outfitHeading(
                            size: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _CloseButton(onTap: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Nombre ─────────────────────────────────────────────────
                  Text(
                    'Nombre de la mesa',
                    style: AppTextStyles.manropeLabel(
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DialogTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    hint: 'Ej. Mesa terraza',
                    autofocus: true,
                    onSubmitted: (_) => _numberFocus.requestFocus(),
                  ),
                  const SizedBox(height: 18),

                  // ── Número ─────────────────────────────────────────────────
                  Text(
                    'Número de mesa',
                    style: AppTextStyles.manropeLabel(
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DialogTextField(
                    controller: _numberController,
                    focusNode: _numberFocus,
                    hint: 'Ej. 12',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSubmitted: (_) => _save(),
                  ),
                  const SizedBox(height: 28),

                  // ── Buttons ────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _CancelButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _SaveButton(onTap: _save)),
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
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          LucideIcons.x,
          size: 14,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onSubmitted;

  const _DialogTextField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      style: AppTextStyles.manropeBody(size: 14, color: AppColors.textPrimary),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
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
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: AppColors.inputFill,
        foregroundColor: AppColors.textMuted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      child: Text(
        'Cancelar',
        style: AppTextStyles.manropeButton(
          size: 15,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      child: Text(
        'Guardar',
        style: AppTextStyles.manropeButton(size: 15),
      ),
    );
  }
}
