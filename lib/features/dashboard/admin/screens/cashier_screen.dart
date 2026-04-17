import 'package:flutter/material.dart';
import 'package:nex_order_app/core/models/cashier_model.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/cashier/cashier_account_row.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/cashier/cashier_date_utils.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/cashier/cashier_filter_bar.dart';
import 'package:nex_order_app/features/dashboard/admin/widgets/cashier/cashier_summary_card.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  final List<ClosedAccount> _accounts = List.of(initialMockAccounts);
  bool _showDesglose = true;
  String _search = '';
  DateTime? _customDate;

  DateTime get _activeDate => _customDate ?? DateTime.now();

  List<ClosedAccount> get _filtered => _accounts
      .where((a) =>
          sameDay(a.closedAt, _activeDate) &&
          (_search.isEmpty ||
              a.tableName.toLowerCase().contains(_search.toLowerCase())))
      .toList()
    ..sort((a, b) => b.closedAt.compareTo(a.closedAt));

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // ── Summary card ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: CashierSummaryCard(
              totalVentas: filtered.fold(0, (s, a) => s + a.total),
              accountCount: filtered.length,
              totalCash: filtered.fold(0, (s, a) => s + a.cashAmount),
              totalCard: filtered.fold(0, (s, a) => s + a.cardAmount),
              showDesglose: _showDesglose,
              onToggleDesglose: () =>
                  setState(() => _showDesglose = !_showDesglose),
            ),
          ),
          const SizedBox(height: 16),

          // ── Filter bar ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CashierFilterBar(
              isToday: _customDate == null,
              customDate: _customDate,
              onSearchChanged: (v) => setState(() => _search = v),
              onTodayPressed: () => setState(() => _customDate = null),
              onDatePicked: (d) => setState(() => _customDate = d),
            ),
          ),
          const SizedBox(height: 16),

          // ── Account list ─────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No hay cuentas cerradas para esta fecha',
                      style: AppTextStyles.manropeBody(
                          size: 14, color: AppColors.textMuted),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        CashierAccountRow(account: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
