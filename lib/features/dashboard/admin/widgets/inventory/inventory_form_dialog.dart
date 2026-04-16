import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/inventory_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

Future<InventoryItem?> showInventoryFormDialog(
  BuildContext context, {
  InventoryItem? item,
}) {
  return showGeneralDialog<InventoryItem>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => InventoryFormDialog(item: item),
    transitionBuilder: (_, anim, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
  );
}

class InventoryFormDialog extends StatefulWidget {
  final InventoryItem? item;
  const InventoryFormDialog({super.key, this.item});

  @override
  State<InventoryFormDialog> createState() => _InventoryFormDialogState();
}

class _InventoryFormDialogState extends State<InventoryFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _quantity;
  late final TextEditingController _unit;
  late final TextEditingController _threshold;
  late String? _category;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _name      = TextEditingController(text: i?.name ?? '');
    _quantity  = TextEditingController(text: i != null ? '${i.quantity}' : '');
    _unit      = TextEditingController(text: i?.unit ?? '');
    _threshold = TextEditingController(
        text: i != null ? '${i.lowStockThreshold}' : '');
    _category  = i?.category;
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _unit.dispose();
    _threshold.dispose();
    super.dispose();
  }

  void _save() {
    final name     = _name.text.trim();
    final quantity = int.tryParse(_quantity.text.trim());
    final unit     = _unit.text.trim();
    final threshold = int.tryParse(_threshold.text.trim()) ?? 5;
    if (name.isEmpty || quantity == null || unit.isEmpty || _category == null) {
      return;
    }

    final result = widget.item?.copyWith(
          name: name,
          quantity: quantity,
          unit: unit,
          category: _category,
          lowStockThreshold: threshold,
        ) ??
        InventoryItem(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          category: _category!,
          quantity: quantity,
          unit: unit,
          lowStockThreshold: threshold,
        );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Blur backdrop ─────────────────────────────────────────────────
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
        ),

        // ── Card ──────────────────────────────────────────────────────────
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
                          _isEdit ? 'Editar artículo' : 'Nuevo artículo',
                          style: AppTextStyles.outfitHeading(
                              size: 20, weight: FontWeight.w600),
                        ),
                      ),
                      _CloseBtn(onTap: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nombre
                  _FieldLabel('Nombre del artículo'),
                  const SizedBox(height: 8),
                  _FormField(
                      controller: _name,
                      hint: 'Ej: Maestro Dobel 750ml',
                      autofocus: true),
                  const SizedBox(height: 18),

                  // Categoría
                  _FieldLabel('Categoría'),
                  const SizedBox(height: 8),
                  _CategoryDropdown(
                    value: _category,
                    onChanged: (v) => setState(() => _category = v),
                  ),
                  const SizedBox(height: 18),

                  // Cantidad + Unidad (side by side)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Cantidad'),
                            const SizedBox(height: 8),
                            _FormField(
                              controller: _quantity,
                              hint: '0',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Unidad'),
                            const SizedBox(height: 8),
                            _FormField(
                                controller: _unit,
                                hint: 'Ej: botellas, latas, litros'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Umbral stock bajo
                  Row(
                    children: [
                      _FieldLabel('Umbral stock bajo'),
                      const SizedBox(width: 6),
                      Text('(alerta cuando sea menor o igual a este valor)',
                          style: AppTextStyles.manropeBody(
                              size: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _threshold,
                    hint: '5',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 28),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _CancelBtn(onTap: () => Navigator.of(context).pop()),
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

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.controller,
    required this.hint,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: AppTextStyles.manropeBody(
          size: 14, color: AppColors.textPrimary),
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
          borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({required this.value, required this.onChanged});

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
        child: DropdownButton<String>(
          value: value,
          hint: Text('Seleccionar categoría',
              style: AppTextStyles.manropeHint(size: 14)),
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1C1A),
          icon: const Icon(LucideIcons.chevronDown,
              size: 16, color: AppColors.textMuted),
          style: AppTextStyles.manropeBody(
              size: 14, color: AppColors.textPrimary),
          items: inventorySections
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
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
