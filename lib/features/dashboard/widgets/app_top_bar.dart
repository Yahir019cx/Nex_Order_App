import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';

// ── Modelo de notificación ────────────────────────────────────────────────────

class _NotifItem {
  final int id;
  final String title;
  final String message;
  final String time;
  bool isRead = false;

  _NotifItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
  });
}

final _mockNotifications = [
  _NotifItem(id: 1, title: 'Nueva orden',      message: 'Mesa 5 ha solicitado la cuenta',  time: 'Hace 5 min'),
  _NotifItem(id: 2, title: 'Inventario bajo',   message: 'Cerveza Corona tiene stock bajo', time: 'Hace 15 min'),
  _NotifItem(id: 3, title: 'Orden completada',  message: 'Mesa 3 ha cerrado su cuenta',     time: 'Hace 30 min'),
];

// ── Widget público ────────────────────────────────────────────────────────────

class AppTopBar extends StatefulWidget {
  final String moduleName;
  final VoidCallback? onLogout;

  const AppTopBar({
    super.key,
    this.moduleName = '',
    this.onLogout,
  });

  static const double height = 64;

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  final _notifLink = LayerLink();
  final _userLink  = LayerLink();

  final _notifPortal = OverlayPortalController();
  final _userPortal  = OverlayPortalController();

  late final List<_NotifItem> _notifications =
      _mockNotifications.map((n) => _NotifItem(
        id: n.id, title: n.title, message: n.message, time: n.time,
      )).toList();

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _toggleNotifications() {
    if (_notifPortal.isShowing) {
      _notifPortal.hide();
    } else {
      if (_userPortal.isShowing) _userPortal.hide();
      // Marcar todas como leídas al abrir
      setState(() {
        for (final n in _notifications) { n.isRead = true; }
      });
      _notifPortal.show();
    }
  }

  void _toggleUserMenu() {
    if (_userPortal.isShowing) {
      _userPortal.hide();
    } else {
      if (_notifPortal.isShowing) _notifPortal.hide();
      _userPortal.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: AppTopBar.height,
          decoration: const BoxDecoration(
            color: Color(0xE61F1F1F),
            border: Border(
              bottom: BorderSide(color: Color(0xFF2A2725), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              _LeftSection(moduleName: widget.moduleName),
              const Spacer(),
              _BellButton(
                link: _notifLink,
                unreadCount: _unreadCount,
                onTap: _toggleNotifications,
                portal: _notifPortal,
                dropdown: TapRegion(
                  onTapOutside: (_) => _notifPortal.hide(),
                  child: _NotificationsDropdown(notifications: _notifications),
                ),
              ),
              const SizedBox(width: 4),
              _UserMenuButton(
                link: _userLink,
                onTap: _toggleUserMenu,
                portal: _userPortal,
                dropdown: TapRegion(
                  onTapOutside: (_) => _userPortal.hide(),
                  child: _UserDropdown(
                    onLogout: () {
                      _userPortal.hide();
                      widget.onLogout?.call();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sección izquierda ─────────────────────────────────────────────────────────

class _LeftSection extends StatelessWidget {
  final String moduleName;
  const _LeftSection({required this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'La Santa Bar',
          style: AppTextStyles.manropeLabel(size: 16, weight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          moduleName,
          style: AppTextStyles.manropeBody(size: 15, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ── Botón campana ─────────────────────────────────────────────────────────────

class _BellButton extends StatelessWidget {
  final LayerLink link;
  final int unreadCount;
  final VoidCallback onTap;
  final OverlayPortalController portal;
  final Widget dropdown;

  const _BellButton({
    required this.link,
    required this.unreadCount,
    required this.onTap,
    required this.portal,
    required this.dropdown,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
        controller: portal,
        overlayChildBuilder: (_) => CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 8),
          child: Align(
            alignment: Alignment.topRight,
            child: dropdown,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(LucideIcons.bell, color: Colors.white, size: 20),
                ),
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Botón usuario ─────────────────────────────────────────────────────────────

class _UserMenuButton extends StatelessWidget {
  final LayerLink link;
  final VoidCallback onTap;
  final OverlayPortalController portal;
  final Widget dropdown;

  const _UserMenuButton({
    required this.link,
    required this.onTap,
    required this.portal,
    required this.dropdown,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
        controller: portal,
        overlayChildBuilder: (_) => CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 8),
          child: Align(
            alignment: Alignment.topRight,
            child: dropdown,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      size: 14,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Admin',
                    style: AppTextStyles.manropeLabel(size: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dropdown notificaciones ───────────────────────────────────────────────────

class _NotificationsDropdown extends StatelessWidget {
  final List<_NotifItem> notifications;
  const _NotificationsDropdown({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        constraints: const BoxConstraints(maxHeight: 380),
        decoration: BoxDecoration(
          color: AppColors.formPanel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3835)),
          boxShadow: const [
            BoxShadow(color: Color(0x44000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  'Notificaciones',
                  style: AppTextStyles.manropeLabel(size: 15, weight: FontWeight.w600),
                ),
              ),
              const Divider(color: Color(0xFF3A3835), height: 1),
              if (notifications.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No hay notificaciones',
                      style: AppTextStyles.manropeBody(color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: Color(0xFF3A3835), height: 1),
                    itemBuilder: (_, i) => _NotifRow(item: notifications[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  final _NotifItem item;
  const _NotifRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: AppTextStyles.manropeLabel(
                      size: 13,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  item.time,
                  style: AppTextStyles.manropeBody(
                    size: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              item.message,
              style: AppTextStyles.manropeBody(size: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dropdown usuario ──────────────────────────────────────────────────────────

class _UserDropdown extends StatelessWidget {
  final VoidCallback onLogout;
  const _UserDropdown({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.formPanel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF3A3835)),
          boxShadow: const [
            BoxShadow(color: Color(0x44000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onLogout,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(LucideIcons.logOut, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    'Cerrar sesión',
                    style: AppTextStyles.manropeLabel(size: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
