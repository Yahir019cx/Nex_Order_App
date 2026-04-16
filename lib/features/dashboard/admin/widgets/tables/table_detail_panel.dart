import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/models/table_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

class TableDetailPanel extends StatefulWidget {
  final TableModel table;
  final List<OrderItem>? items;
  final bool isAdmin;
  final VoidCallback onClose;
  final VoidCallback? onAddProducts;
  final void Function(String name, int qty)? onRemoveItem;

  const TableDetailPanel({
    super.key,
    required this.table,
    this.items,
    this.isAdmin = true,
    required this.onClose,
    this.onAddProducts,
    this.onRemoveItem,
  });

  @override
  State<TableDetailPanel> createState() => _TableDetailPanelState();
}

class _TableDetailPanelState extends State<TableDetailPanel> {
  String? _selectedItemName;
  int _removeQty = 1;

  List<OrderItem> get _items => widget.items ?? widget.table.items;
  double get _subtotal => _items.fold(0, (sum, item) => sum + item.total);

  void _selectItem(OrderItem item) {
    setState(() {
      if (_selectedItemName == item.name) {
        _selectedItemName = null;
        _removeQty = 1;
      } else {
        _selectedItemName = item.name;
        _removeQty = 1;
      }
    });
  }

  void _confirmRemove() {
    if (_selectedItemName == null) return;
    widget.onRemoveItem?.call(_selectedItemName!, _removeQty);
    setState(() {
      _selectedItemName = null;
      _removeQty = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1917),
        border: Border(
          left: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 32,
            offset: const Offset(-12, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.table.name,
                    style: AppTextStyles.outfitHeading(
                      size: 26,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                _IconBtn(icon: LucideIcons.x, onTap: widget.onClose),
              ],
            ),
          ),

          // ── Badge + capacidad ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 0),
            child: Row(
              children: [
                _StatusBadge(status: widget.table.status),
                const SizedBox(width: 12),
                Text(
                  '${widget.table.capacity} personas',
                  style: AppTextStyles.manropeBody(
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 20),

          // ── Label ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              'PRODUCTOS',
              style: AppTextStyles.manropeLabel(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Lista ───────────────────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (_, i) {
                final item = _items[i];
                final selected = item.name == _selectedItemName;
                return _OrderItemRow(
                  item: item,
                  selected: selected,
                  isAdmin: widget.isAdmin,
                  removeQty: selected ? _removeQty : 1,
                  onTap: widget.isAdmin ? () => _selectItem(item) : null,
                  onDecrementRemove: selected
                      ? () {
                          if (_removeQty > 1) {
                            setState(() => _removeQty--);
                          }
                        }
                      : null,
                  onIncrementRemove: selected
                      ? () {
                          if (_removeQty < item.quantity) {
                            setState(() => _removeQty++);
                          }
                        }
                      : null,
                  onConfirmRemove: selected ? _confirmRemove : null,
                );
              },
            ),
          ),

          // ── Totales ─────────────────────────────────────────────────────────
          Divider(color: AppColors.border.withValues(alpha: 0.5), height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
            child: Column(
              children: [
                _TotalRow(
                  label: 'Subtotal',
                  amount: _subtotal,
                  labelStyle: AppTextStyles.manropeBody(
                      size: 14, color: AppColors.textMuted),
                  amountStyle: AppTextStyles.manropeBody(
                      size: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                _TotalRow(
                  label: 'Total',
                  amount: _subtotal,
                  labelStyle: AppTextStyles.manropeLabel(
                      size: 17, weight: FontWeight.w700),
                  amountStyle: AppTextStyles.outfitHeading(
                      size: 22, weight: FontWeight.w700, color: AppColors.accent),
                ),
              ],
            ),
          ),

          // ── Botones ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: Column(
              children: [
                _PanelButton(
                  icon: LucideIcons.plusCircle,
                  label: 'Agregar productos',
                  onTap: widget.onAddProducts ?? () {},
                  filled: false,
                ),
                const SizedBox(height: 12),
                _PanelButton(
                  icon: LucideIcons.printer,
                  label: 'Imprimir ticket',
                  onTap: () {},
                  filled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order item row ────────────────────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  final bool selected;
  final bool isAdmin;
  final int removeQty;
  final VoidCallback? onTap;
  final VoidCallback? onDecrementRemove;
  final VoidCallback? onIncrementRemove;
  final VoidCallback? onConfirmRemove;

  const _OrderItemRow({
    required this.item,
    required this.selected,
    required this.isAdmin,
    required this.removeQty,
    this.onTap,
    this.onDecrementRemove,
    this.onIncrementRemove,
    this.onConfirmRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.inputFill
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          // ── Fila principal ──────────────────────────────────────────────────
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.name,
                          style: AppTextStyles.manropeBody(
                            size: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text: '  x${item.quantity}',
                          style: AppTextStyles.manropeBody(
                            size: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '\$${item.total.toStringAsFixed(0)}',
                  style: AppTextStyles.manropeLabel(
                      size: 15, weight: FontWeight.w500),
                ),
                if (isAdmin) ...[
                  const SizedBox(width: 10),
                  Icon(
                    selected ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                ],
              ],
            ),
          ),

          // ── Control de eliminación (solo cuando seleccionado) ───────────────
          if (selected)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Text(
                    'Eliminar:',
                    style: AppTextStyles.manropeBody(
                        size: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 10),
                  _SmallQtyBtn(
                    icon: LucideIcons.minus,
                    onTap: onDecrementRemove ?? () {},
                    enabled: removeQty > 1,
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '$removeQty',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLabel(
                          size: 15, weight: FontWeight.w700),
                    ),
                  ),
                  _SmallQtyBtn(
                    icon: LucideIcons.plus,
                    onTap: onIncrementRemove ?? () {},
                    enabled: removeQty < item.quantity,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onConfirmRemove,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.trash2,
                              size: 13, color: Color(0xFFEF4444)),
                          const SizedBox(width: 6),
                          Text(
                            'Confirmar',
                            style: AppTextStyles.manropeLabel(
                              size: 13,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  const _SmallQtyBtn(
      {required this.icon, required this.onTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          icon,
          size: 13,
          color: enabled ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }
}

// ── Subwidgets ────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final TableStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 7,
              height: 7,
              decoration:
                  BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(status.label,
              style: AppTextStyles.manropeBody(size: 13, color: color)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final TextStyle labelStyle;
  final TextStyle amountStyle;
  const _TotalRow(
      {required this.label,
      required this.amount,
      required this.labelStyle,
      required this.amountStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text('\$${amount.toStringAsFixed(0)}', style: amountStyle),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 15, color: AppColors.textMuted),
      ),
    );
  }
}

class _PanelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _PanelButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      required this.filled});

  @override
  Widget build(BuildContext context) {
    final bg = filled ? AppColors.accent : AppColors.inputFill;
    final fg = filled ? Colors.white : AppColors.textPrimary;
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 17, color: fg),
        label: Text(label,
            style: AppTextStyles.manropeButton(size: 15, color: fg)),
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: filled
                ? BorderSide.none
                : BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}
