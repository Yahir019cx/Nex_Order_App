import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/table_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

enum TableFilter { all, available, occupied, billRequested }

extension TableFilterX on TableFilter {
  String label(int count) => switch (this) {
        TableFilter.all           => 'Todas ($count)',
        TableFilter.available     => 'Disponibles ($count)',
        TableFilter.occupied      => 'Ocupadas ($count)',
        TableFilter.billRequested => 'Cuenta pedida ($count)',
      };

  bool matches(TableModel t) => switch (this) {
        TableFilter.all           => true,
        TableFilter.available     => t.status == TableStatus.available,
        TableFilter.occupied      => t.status == TableStatus.occupied,
        TableFilter.billRequested => t.status == TableStatus.billRequested,
      };
}

class TablesFilterBar extends StatelessWidget {
  final TableFilter active;
  final List<TableModel> tables;
  final ValueChanged<TableFilter> onChanged;

  const TablesFilterBar({
    super.key,
    required this.active,
    required this.tables,
    required this.onChanged,
  });

  int _count(TableFilter f) => tables.where(f.matches).length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: TableFilter.values
            .map((f) => _FilterChip(
                  filter: f,
                  count: _count(f),
                  isActive: f == active,
                  onTap: () => onChanged(f),
                ))
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final TableFilter filter;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.filter,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isActive
                    ? AppColors.accent
                    : const Color(0xFF3A3835),
                width: 1,
              ),
            ),
            child: Text(
              filter.label(count),
              style: AppTextStyles.manropeLabel(
                size: 13,
                weight: FontWeight.w500,
                color: isActive
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
