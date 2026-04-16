import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/product_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

Future<ProductModel?> showProductFormDialog(
  BuildContext context, {
  ProductModel? product,
}) {
  return showGeneralDialog<ProductModel>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => ProductFormDialog(product: product),
    transitionBuilder: (_, anim, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
      child: child,
    ),
  );
}

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _desc;
  late final TextEditingController _price;
  late String? _section;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name  = TextEditingController(text: p?.name ?? '');
    _desc  = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(0) : '');
    _section = p?.category;
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _price.dispose();
    super.dispose();
  }

  void _save() {
    final name  = _name.text.trim();
    final price = double.tryParse(_price.text.trim());
    if (name.isEmpty || price == null || _section == null) return;

    final result = widget.product?.copyWith(
          name: name,
          description: _desc.text.trim(),
          price: price,
          category: _section,
        ) ??
        ProductModel(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          description: _desc.text.trim(),
          price: price,
          category: _section!,
        );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Blur backdrop ───────────────────────────────────────────────────
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.55)),
          ),
        ),

        // ── Card ────────────────────────────────────────────────────────────
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
                          _isEdit ? 'Editar producto' : 'Nuevo producto',
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
                  _FieldLabel('Nombre del producto'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _name,
                    hint: 'Ej: Cerveza Corona',
                    autofocus: true,
                  ),
                  const SizedBox(height: 18),

                  // Descripción
                  Row(
                    children: [
                      _FieldLabel('Descripción'),
                      const SizedBox(width: 6),
                      Text('(opcional)',
                          style: AppTextStyles.manropeBody(
                              size: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _desc,
                    hint: 'Ej: Cerveza clara 355ml',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 18),

                  // Precio
                  _FieldLabel('Precio'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: _price,
                    hint: '0.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Categoría
                  _FieldLabel('Categoría'),
                  const SizedBox(height: 8),
                  _SectionDropdown(
                    value: _section,
                    onChanged: (v) => setState(() => _section = v),
                  ),
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
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _FormField({
    required this.controller,
    required this.hint,
    this.autofocus = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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

class _SectionDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _SectionDropdown({required this.value, required this.onChanged});

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
          items: productSections
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
