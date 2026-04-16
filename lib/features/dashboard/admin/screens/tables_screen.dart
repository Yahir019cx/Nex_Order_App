import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/table_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/tables_filter_bar.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/tables/tables_grid.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  TableFilter _filter = TableFilter.all;

  List<TableModel> get _filtered =>
      mockTables.where(_filter.matches).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TablesFilterBar(
            active: _filter,
            tables: mockTables,
            onChanged: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: TablesGrid(
              tables: _filtered,
              onAddTable: () {},
            ),
          ),
        ],
      ),
    );
  }
}
