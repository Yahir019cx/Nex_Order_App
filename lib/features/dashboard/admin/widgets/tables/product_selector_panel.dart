import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/product_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

// Callback con cantidad
typedef OnAddProduct = void Function(ProductModel product, int qty);

class ProductSelectorPanel extends StatefulWidget {
  final VoidCallback onClose;
  final OnAddProduct onAddProduct;

  const ProductSelectorPanel({
    super.key,
    required this.onClose,
    required this.onAddProduct,
  });

  @override
  State<ProductSelectorPanel> createState() => _ProductSelectorPanelState();
}

class _ProductSelectorPanelState extends State<ProductSelectorPanel> {
  String _activeCategory = 'Todas';
  String _search = '';

  List<ProductModel> get _filtered => initialMockProducts.where((p) {
        final matchesCategory =
            _activeCategory == 'Todas' || p.category == _activeCategory;
        final matchesSearch =
            p.name.toLowerCase().contains(_search.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1917),
        border: Border(
          left: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
          right: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(-8, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Agregar productos',
                    style: AppTextStyles.outfitHeading(
                      size: 20,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      size: 15,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Search ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: AppTextStyles.manropeBody(
                  size: 14, color: AppColors.textPrimary),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                hintStyle: AppTextStyles.manropeHint(size: 14),
                prefixIcon: const Icon(
                  LucideIcons.search,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
            ),
          ),
          const SizedBox(height: 14),

          // ── Categorías ─────────────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: productCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = productCategories[i];
                final active = cat == _activeCategory;
                return GestureDetector(
                  onTap: () => setState(() => _activeCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.textPrimary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: active
                            ? AppColors.textPrimary
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: AppTextStyles.manropeLabel(
                        size: 13,
                        color: active
                            ? AppColors.background
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Grid de productos ──────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.7,
              ),
              itemCount: _filtered.length,
              itemBuilder: (_, i) => _ProductCard(
                product: _filtered[i],
                onTap: (qty) => widget.onAddProduct(_filtered[i], qty),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final void Function(int qty) onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  int _qty = 1;

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 180),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.88)
      .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  late final Animation<double> _border =
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _ctrl.forward();
    widget.onTap(_qty);
    setState(() => _qty = 1);
    await _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _border,
          builder: (_, child) => Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.formPanel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color.lerp(AppColors.border, AppColors.accent, _border.value)!,
                width: 1.0 + _border.value,
              ),
            ),
            child: child,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: AppTextStyles.manropeLabel(size: 14, weight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '\$${widget.product.price.toStringAsFixed(0)}',
                style: AppTextStyles.outfitHeading(size: 19, weight: FontWeight.w700),
              ),
              const Spacer(),
              Row(
                children: [
                  // Badge categoría
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.product.category,
                        style: AppTextStyles.manropeBody(size: 10, color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Contador cantidad
                  _QtyControl(
                    qty: _qty,
                    onDecrement: () {
                      if (_qty > 1) setState(() => _qty--);
                    },
                    onIncrement: () => setState(() => _qty++),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyBtn(icon: LucideIcons.minus, onTap: onDecrement),
        SizedBox(
          width: 28,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: AppTextStyles.manropeLabel(size: 15, weight: FontWeight.w700),
          ),
        ),
        _QtyBtn(icon: LucideIcons.plus, onTap: onIncrement),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 13, color: AppColors.textMuted),
      ),
    );
  }
}
