import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/table_model.dart';
import 'table_card.dart';
import 'add_table_card.dart';

class TablesGrid extends StatelessWidget {
  final List<TableModel> tables;
  final VoidCallback? onAddTable;

  const TablesGrid({super.key, required this.tables, this.onAddTable});

  @override
  Widget build(BuildContext context) {
    // +1 para la card de agregar mesa
    final itemCount = tables.length + 1;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: itemCount,
      itemBuilder: (_, i) {
        if (i < tables.length) {
          return TableCard(table: tables[i]);
        }
        return AddTableCard(onTap: onAddTable);
      },
    );
  }
}
