import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/inventory_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/inventory/inventory_card.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/inventory/inventory_form_dialog.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/products/products_top_bar.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<InventoryItem> _items = List.of(initialMockInventory);
  final List<String> _sections = List.of(inventorySections);
  String _activeSection = 'Todos';
  String _search = '';

  List<InventoryItem> get _filtered => _items.where((i) {
        final matchSection =
            _activeSection == 'Todos' || i.category == _activeSection;
        final matchSearch = _search.isEmpty ||
            i.name.toLowerCase().contains(_search.toLowerCase());
        return matchSection && matchSearch;
      }).toList();

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<void> _openForm({InventoryItem? item}) async {
    final result = await showInventoryFormDialog(context, item: item);
    if (result == null) return;
    setState(() {
      final idx = _items.indexWhere((i) => i.id == result.id);
      if (idx >= 0) {
        _items[idx] = result;
      } else {
        _items.add(result);
        if (!_sections.contains(result.category)) {
          _sections.add(result.category);
        }
      }
      _activeSection = result.category;
    });
  }

  void _delete(InventoryItem item) {
    setState(() => _items.removeWhere((i) => i.id == item.id));
  }

  void _increment(InventoryItem item) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == item.id);
      if (idx >= 0) {
        _items[idx] = item.copyWith(quantity: item.quantity + 1);
      }
    });
  }

  void _decrement(InventoryItem item) {
    if (item.quantity <= 0) return;
    setState(() {
      final idx = _items.indexWhere((i) => i.id == item.id);
      if (idx >= 0) {
        _items[idx] = item.copyWith(quantity: item.quantity - 1);
      }
    });
  }

  // ── Agregar categoría ─────────────────────────────────────────────────────

  void _addSection() {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1E1C1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 460,
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nueva categoría',
                    style: AppTextStyles.outfitHeading(
                        size: 20, weight: FontWeight.w600)),
                const SizedBox(height: 20),
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  style: AppTextStyles.manropeBody(
                      size: 14, color: AppColors.textPrimary),
                  cursorColor: AppColors.accent,
                  onSubmitted: (_) => _submitSection(ctrl),
                  decoration: InputDecoration(
                    hintText: 'Ej: Destilados',
                    hintStyle: AppTextStyles.manropeHint(size: 14),
                    filled: true,
                    fillColor: AppColors.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.accent, width: 1.5)),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.inputFill,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Cancelar',
                            style: AppTextStyles.manropeButton(
                                size: 15, color: AppColors.textMuted)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16)),
                        onPressed: () => _submitSection(ctrl),
                        child: Text('Agregar',
                            style: AppTextStyles.manropeButton(size: 15)),
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

  void _submitSection(TextEditingController ctrl) {
    final name = ctrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      if (!_sections.contains(name)) _sections.add(name);
      _activeSection = name;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar ──────────────────────────────────────────────────────
          ProductsTopBar(
            sections: _sections,
            activeSection: _activeSection,
            search: _search,
            onSectionChanged: (s) => setState(() => _activeSection = s),
            onSearchChanged: (v) => setState(() => _search = v),
            onAddSection: _addSection,
            onAction: _openForm,
            actionLabel: 'Agregar artículo',
          ),

          const SizedBox(height: 16),
          Divider(
              color: AppColors.border.withValues(alpha: 0.5),
              height: 1,
              indent: 24,
              endIndent: 24),
          const SizedBox(height: 20),

          // ── Grid ─────────────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('Sin artículos en esta categoría',
                        style: AppTextStyles.manropeBody(
                            size: 14, color: AppColors.textMuted)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final item = filtered[i];
                      return InventoryCard(
                        item: item,
                        onEdit: () => _openForm(item: item),
                        onDelete: () => _delete(item),
                        onIncrement: () => _increment(item),
                        onDecrement: () => _decrement(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
