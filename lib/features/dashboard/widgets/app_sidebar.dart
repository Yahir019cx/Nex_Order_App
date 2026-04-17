import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'package:nex_order_app/core/theme/app_text_styles.dart';
import 'app_top_bar.dart';

// ── Modelo de item ────────────────────────────────────────────────────────────

class SidebarItem {
  final String id;
  final String label;
  final IconData icon;
  const SidebarItem({required this.id, required this.label, required this.icon});
}

const _menuItems = [
  SidebarItem(id: 'home',      label: 'Inicio',        icon: LucideIcons.home),
  SidebarItem(id: 'tables',    label: 'Mesas',          icon: LucideIcons.galleryHorizontal),
  SidebarItem(id: 'products',  label: 'Productos',      icon: LucideIcons.package),
  SidebarItem(id: 'inventory', label: 'Inventario',     icon: LucideIcons.warehouse),
  SidebarItem(id: 'users',     label: 'Usuarios',       icon: LucideIcons.users),
  SidebarItem(id: 'cashier',   label: 'Caja',           icon: LucideIcons.coins),
  SidebarItem(id: 'cut',       label: 'Corte',          icon: LucideIcons.calculator),
  SidebarItem(id: 'settings',  label: 'Configuración',  icon: LucideIcons.settings),
];

// ── Widget público ────────────────────────────────────────────────────────────

class AppSidebar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final String activeId;
  final ValueChanged<String> onNavigate;

  const AppSidebar({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.activeId,
    required this.onNavigate,
  });

  static const double expandedWidth  = 256;
  static const double collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? expandedWidth : collapsedWidth,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 32,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarHeader(isExpanded: isExpanded, onToggle: onToggle),
          const _SidebarDivider(),
          Expanded(
            child: _SidebarNav(
              isExpanded: isExpanded,
              activeId: activeId,
              onNavigate: onNavigate,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SidebarDivider(),
                      _SidebarFooter(),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  final VoidCallback onToggle;
  const _SidebarHeader({required this.isExpanded, required this.onToggle});

  // isExpanded solo se usa para pasar al constructor, el layout real
  // depende del ancho disponible via LayoutBuilder
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 160;
        return InkWell(
          onTap: onToggle,
          child: SizedBox(
            height: AppTopBar.height,
            child: wide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.utensils, color: Colors.white, size: 24),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'NexOrder Pro',
                          style: AppTextStyles.outfitHeading(
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Icon(
                      LucideIcons.utensils,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ── Nav ───────────────────────────────────────────────────────────────────────

class _SidebarNav extends StatelessWidget {
  final bool isExpanded;
  final String activeId;
  final ValueChanged<String> onNavigate;
  const _SidebarNav({
    required this.isExpanded,
    required this.activeId,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 28, 10, 16),
      children: _menuItems
          .map((item) => _NavItem(
                item: item,
                isExpanded: isExpanded,
                isActive: activeId == item.id,
                onTap: () => onNavigate(item.id),
              ))
          .toList(),
    );
  }
}

class _NavItem extends StatelessWidget {
  final SidebarItem item;
  final bool isExpanded;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem({
    required this.item,
    required this.isExpanded,
    required this.isActive,
    required this.onTap,
  });

  Color get _iconColor => isActive
      ? Colors.white
      : Colors.white.withValues(alpha: 0.5);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Cambia layout solo cuando hay espacio suficiente para el Row expandido
        final wide = constraints.maxWidth > 90;
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: wide ? _expanded() : _collapsed(),
            ),
          ),
        );
      },
    );
  }

  // Estado expandido: fondo ancho + icono + label
  Widget _expanded() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 22, color: _iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.manropeLabel(
                size: 15,
                weight: FontWeight.w500,
                color: _iconColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Estado colapsado: cuadrado centrado con solo el icono
  Widget _collapsed() {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(item.icon, size: 22, color: _iconColor),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'La Santa Bar',
            style: AppTextStyles.manropeLabel(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.mapPin,
                size: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Av. Alejandro de la cruz Saucedo',
                  style: AppTextStyles.manropeBody(
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Divider ───────────────────────────────────────────────────────────────────

class _SidebarDivider extends StatelessWidget {
  const _SidebarDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Color(0xFF2A2725), height: 1, thickness: 1);
  }
}
