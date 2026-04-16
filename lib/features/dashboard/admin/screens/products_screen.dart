import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/product_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/products/product_card.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/products/product_form_dialog.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/products/products_top_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<ProductModel> _products = List.of(initialMockProducts);
  final List<String> _sections = List.of(productSections);
  String _activeSection = 'Todos';
  String _search = '';

  List<ProductModel> get _filtered => _products.where((p) {
        final matchSection =
            _activeSection == 'Todos' || p.category == _activeSection;
        final matchSearch = _search.isEmpty ||
            p.name.toLowerCase().contains(_search.toLowerCase());
        return matchSection && matchSearch;
      }).toList();

  // ── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> _openForm({ProductModel? product}) async {
    final result = await showProductFormDialog(context, product: product);
    if (result == null) return;
    setState(() {
      final idx = _products.indexWhere((p) => p.id == result.id);
      if (idx >= 0) {
        _products[idx] = result;
      } else {
        _products.add(result);
        if (!_sections.contains(result.category)) {
          _sections.add(result.category);
        }
      }
      _activeSection = result.category;
    });
  }

  void _togglePause(ProductModel product) {
    setState(() {
      final idx = _products.indexWhere((p) => p.id == product.id);
      if (idx >= 0) _products[idx] = product.copyWith(isActive: !product.isActive);
    });
  }

  void _delete(ProductModel product) {
    setState(() => _products.removeWhere((p) => p.id == product.id));
  }

  // ── Agregar sección ───────────────────────────────────────────────────────

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
                  onSubmitted: (_) {
                    final name = ctrl.text.trim();
                    if (name.isEmpty) return;
                    setState(() {
                      if (!_sections.contains(name)) _sections.add(name);
                      _activeSection = name;
                    });
                    Navigator.pop(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'Ej: Cócteles',
                    hintStyle: AppTextStyles.manropeHint(size: 14),
                    filled: true,
                    fillColor: AppColors.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border)),
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
                        onPressed: () {
                          final name = ctrl.text.trim();
                          if (name.isEmpty) return;
                          setState(() {
                            if (!_sections.contains(name)) {
                              _sections.add(name);
                            }
                            _activeSection = name;
                          });
                          Navigator.pop(context);
                        },
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: tabs + buscador + botón ──────────────────────────────
          ProductsTopBar(
            sections: _sections,
            activeSection: _activeSection,
            search: _search,
            onSectionChanged: (s) => setState(() => _activeSection = s),
            onSearchChanged: (v) => setState(() => _search = v),
            onAddSection: _addSection,
            onAction: _openForm,
          ),

          const SizedBox(height: 16),
          Divider(
              color: AppColors.border.withValues(alpha: 0.5),
              height: 1,
              indent: 24,
              endIndent: 24),
          const SizedBox(height: 20),

          // ── Grid ────────────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('Sin productos en esta sección',
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
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final p = _filtered[i];
                      return ProductCard(
                        product: p,
                        onEdit: () => _openForm(product: p),
                        onTogglePause: () => _togglePause(p),
                        onDelete: () => _delete(p),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
