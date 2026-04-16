import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class ProductsTopBar extends StatelessWidget {
  /// Secciones disponibles (sin "Todos", se agrega internamente).
  final List<String> sections;

  /// Sección activa. Usa "Todos" para la pestaña global.
  final String activeSection;

  /// Texto del buscador.
  final String search;

  /// Label del botón de acción principal.
  final String actionLabel;

  final ValueChanged<String> onSectionChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddSection;
  final VoidCallback onAction;

  const ProductsTopBar({
    super.key,
    required this.sections,
    required this.activeSection,
    required this.search,
    required this.onSectionChanged,
    required this.onSearchChanged,
    required this.onAddSection,
    required this.onAction,
    this.actionLabel = 'Agregar producto',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Tabs + "+" ──────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _SectionTab(
                    label: 'Todos',
                    active: activeSection == 'Todos',
                    onTap: () => onSectionChanged('Todos'),
                  ),
                  ...sections.map((s) => _SectionTab(
                        label: s,
                        active: s == activeSection,
                        onTap: () => onSectionChanged(s),
                      )),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onAddSection,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(LucideIcons.plus,
                          size: 16, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // ── Buscador ────────────────────────────────────────────────────
          SizedBox(
            width: 220,
            child: TextField(
              onChanged: onSearchChanged,
              style: AppTextStyles.manropeBody(
                  size: 13, color: AppColors.textPrimary),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                hintStyle: AppTextStyles.manropeHint(size: 13),
                prefixIcon: const Icon(LucideIcons.search,
                    size: 15, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.inputFill,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.accent, width: 1.5)),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // ── Botón acción ────────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
            label: Text(actionLabel,
                style: AppTextStyles.manropeButton(size: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section tab ───────────────────────────────────────────────────────────────

class _SectionTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SectionTab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.manropeLabel(
                size: 15,
                weight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2,
              width: active ? 28 : 0,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
