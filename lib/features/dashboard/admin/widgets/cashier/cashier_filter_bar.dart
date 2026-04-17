import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'cashier_date_utils.dart';

class CashierFilterBar extends StatelessWidget {
  final bool isToday;
  final DateTime? customDate;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onTodayPressed;
  final ValueChanged<DateTime> onDatePicked;

  const CashierFilterBar({
    super.key,
    required this.isToday,
    required this.customDate,
    required this.onSearchChanged,
    required this.onTodayPressed,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearchChanged,
            style: AppTextStyles.manropeBody(
                size: 13, color: AppColors.textPrimary),
            cursorColor: AppColors.accent,
            decoration: InputDecoration(
              hintText: 'Buscar por mesa...',
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
                  borderSide: const BorderSide(
                      color: AppColors.accent, width: 1.5)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _FilterChip(
          label: 'Hoy',
          active: isToday,
          onTap: onTodayPressed,
        ),
        const SizedBox(width: 8),
        _DatePickerButton(
          selectedDate: customDate,
          isActive: !isToday,
          onPick: onDatePicked,
        ),
      ],
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.inputFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: active ? AppColors.accent : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.manropeLabel(
              size: 13,
              weight: FontWeight.w600,
              color: active ? Colors.white : AppColors.textMuted),
        ),
      ),
    );
  }
}

// ── Date picker button ────────────────────────────────────────────────────────

class _DatePickerButton extends StatefulWidget {
  final DateTime? selectedDate;
  final bool isActive;
  final ValueChanged<DateTime> onPick;
  const _DatePickerButton({
    this.selectedDate,
    required this.isActive,
    required this.onPick,
  });

  @override
  State<_DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<_DatePickerButton> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  late final ValueNotifier<DateTime> _monthNotifier;

  @override
  void initState() {
    super.initState();
    final base = widget.selectedDate ?? DateTime.now();
    _monthNotifier = ValueNotifier(DateTime(base.year, base.month));
  }

  @override
  void dispose() {
    _entry?.remove();
    _entry = null;
    _monthNotifier.dispose();
    super.dispose();
  }

  bool get _isOpen => _entry != null;

  void _toggle() => _isOpen ? _hide() : _show();

  void _show() {
    final base = widget.selectedDate ?? DateTime.now();
    _monthNotifier.value = DateTime(base.year, base.month);

    _entry = OverlayEntry(builder: (_) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hide,
        child: Stack(
          children: [
            Positioned.fill(child: const AbsorbPointer()),
            CompositedTransformFollower(
              link: _link,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: _CalendarCard(
                    monthNotifier: _monthNotifier,
                    selectedDate: widget.selectedDate,
                    onSelect: (d) {
                      widget.onPick(d);
                      _hide();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isActive && widget.selectedDate != null
        ? fmtDate(widget.selectedDate!)
        : null;

    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color:
                widget.isActive ? AppColors.accent : AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    widget.isActive ? AppColors.accent : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.calendar,
                  size: 15,
                  color: widget.isActive
                      ? Colors.white
                      : AppColors.textMuted),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(label,
                    style: AppTextStyles.manropeLabel(
                        size: 13,
                        weight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Calendar card ─────────────────────────────────────────────────────────────

class _CalendarCard extends StatelessWidget {
  final ValueNotifier<DateTime> monthNotifier;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelect;

  const _CalendarCard({
    required this.monthNotifier,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: monthNotifier,
      builder: (context, month, child) {
        final firstDay  = DateTime(month.year, month.month, 1);
        final offset     = firstDay.weekday % 7;
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
        final today      = DateTime.now();

        return Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1C1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.border.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nav
              Row(
                children: [
                  _NavBtn(
                    icon: LucideIcons.chevronLeft,
                    onTap: () => monthNotifier.value =
                        DateTime(month.year, month.month - 1),
                  ),
                  Expanded(
                    child: Text(
                      fmtMonthYear(month),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.manropeLabel(
                          size: 14, weight: FontWeight.w600),
                    ),
                  ),
                  _NavBtn(
                    icon: LucideIcons.chevronRight,
                    onTap: () => monthNotifier.value =
                        DateTime(month.year, month.month + 1),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Day headers
              Row(
                children: ['D', 'L', 'M', 'M', 'J', 'V', 'S']
                    .map((d) => Expanded(
                          child: Text(d,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.manropeBody(
                                  size: 12,
                                  color: AppColors.textMuted)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),

              // Day grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemCount: offset + daysInMonth,
                itemBuilder: (_, i) {
                  if (i < offset) return const SizedBox();
                  final day = DateTime(
                      month.year, month.month, i - offset + 1);
                  final isSel = selectedDate != null &&
                      sameDay(day, selectedDate!);
                  final isToday = sameDay(day, today);

                  return GestureDetector(
                    onTap: () => onSelect(day),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.accent
                            : isToday
                                ? AppColors.accent.withValues(alpha: 0.2)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: AppTextStyles.manropeBody(
                          size: 13,
                          color: isSel
                              ? Colors.white
                              : isToday
                                  ? AppColors.accent
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: AppColors.textMuted),
        ),
      );
}
