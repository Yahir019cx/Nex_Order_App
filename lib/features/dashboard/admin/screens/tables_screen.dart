import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/product_model.dart';
import 'package:nex_order_app/core/models/table_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/add_table_dialog.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/open_account_dialog.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/product_selector_panel.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/table_detail_panel.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/tables_filter_bar.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/tables_grid.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  TableFilter _filter = TableFilter.all;
  TableModel? _selected;
  bool _showProducts = false;
  List<OrderItem> _orderItems = [];

  List<TableModel> get _filtered => mockTables.where(_filter.matches).toList();

  void _handleTableTap(TableModel table) {
    if (table.status == TableStatus.available) {
      showOpenAccountDialog(context, table.name);
    } else {
      setState(() {
        if (_selected?.id == table.id) {
          _selected = null;
          _showProducts = false;
          _orderItems = [];
        } else {
          _selected = table;
          _showProducts = false;
          _orderItems = List.of(table.items);
        }
      });
    }
  }

  void _removeItem(String name, int qty) {
    setState(() {
      final idx = _orderItems.indexWhere((i) => i.name == name);
      if (idx < 0) return;
      final item = _orderItems[idx];
      final remaining = item.quantity - qty;
      if (remaining <= 0) {
        _orderItems.removeAt(idx);
      } else {
        _orderItems[idx] = OrderItem(
          name: item.name,
          quantity: remaining,
          unitPrice: item.unitPrice,
        );
      }
    });
  }

  void _addProduct(ProductModel product, int qty) {
    setState(() {
      final idx = _orderItems.indexWhere((i) => i.name == product.name);
      if (idx >= 0) {
        final existing = _orderItems[idx];
        _orderItems[idx] = OrderItem(
          name: existing.name,
          quantity: existing.quantity + qty,
          unitPrice: existing.unitPrice,
        );
      } else {
        _orderItems.add(OrderItem(
          name: product.name,
          quantity: qty,
          unitPrice: product.price,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final panelOpen = _selected != null;

    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // ── Contenido principal ───────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TablesFilterBar(
                active: _filter,
                tables: mockTables,
                onChanged: (f) => setState(() {
                  _filter = f;
                  _selected = null;
                  _showProducts = false;
                }),
              ),
              Expanded(
                child: TablesGrid(
                  tables: _filtered,
                  selectedId: _selected?.id,
                  onTableTap: _handleTableTap,
                  onAddTable: () => showAddTableDialog(context),
                ),
              ),
            ],
          ),

          // ── Blur overlay ──────────────────────────────────────────────────
          if (panelOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() {
                  _selected = null;
                  _showProducts = false;
                }),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),

          // ── Paneles (selector izquierda + detalle derecha) ────────────────
          if (panelOpen)
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const detailWidth = 460.0;
                  final selectorWidth = constraints.maxWidth - detailWidth;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Panel selector de productos
                      AnimatedSlide(
                        offset: _showProducts
                            ? Offset.zero
                            : const Offset(1, 0),
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeInOut,
                        child: AnimatedOpacity(
                          opacity: _showProducts ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: SizedBox(
                            width: selectorWidth,
                            child: ProductSelectorPanel(
                              onClose: () =>
                                  setState(() => _showProducts = false),
                              onAddProduct: _addProduct,
                            ),
                          ),
                        ),
                      ),

                      // Panel detalle de mesa
                      TableDetailPanel(
                        key: ValueKey(_selected!.id),
                        table: _selected!,
                        items: _orderItems,
                        onClose: () => setState(() {
                          _selected = null;
                          _showProducts = false;
                          _orderItems = [];
                        }),
                        onAddProducts: () =>
                            setState(() => _showProducts = !_showProducts),
                        onRemoveItem: _removeItem,
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
