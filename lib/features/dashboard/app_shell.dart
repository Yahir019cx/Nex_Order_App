import 'package:flutter/material.dart';
import 'package:nex_order_app/core/theme/app_colors.dart';
import 'admin/screens/cashier_screen.dart';
import 'admin/screens/home_screen.dart';
import 'admin/screens/inventory_screen.dart';
import 'admin/screens/products_screen.dart';
import 'admin/screens/tables_screen.dart';
import 'admin/screens/users_screen.dart';
import 'widgets/app_sidebar.dart';
import 'widgets/app_top_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isExpanded = true;
  String _activeId = 'home';

  void _handleToggle() => setState(() => _isExpanded = !_isExpanded);

  void _handleNavigate(String id) => setState(() => _activeId = id);

  void _handleLogout() => Navigator.pushReplacementNamed(context, '/');

  String get _moduleName => switch (_activeId) {
        'home'      => 'Inicio',
        'tables'    => 'Gestión de Mesas',
        'products'  => 'Productos',
        'inventory' => 'Inventario',
        'users'     => 'Usuarios',
        'cashier'   => 'Caja',
        'cut'       => 'Corte de Caja',
        'settings'  => 'Configuración',
        _           => '',
      };

  Widget get _screen => switch (_activeId) {
        'tables'    => const TablesScreen(),
        'products'  => const ProductsScreen(),
        'inventory' => const InventoryScreen(),
        'users'     => const UsersScreen(),
        'cashier'   => const CashierScreen(),
        _           => const HomeScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          AppSidebar(
            isExpanded: _isExpanded,
            onToggle: _handleToggle,
            activeId: _activeId,
            onNavigate: _handleNavigate,
          ),
          Expanded(
            child: Column(
              children: [
                AppTopBar(
                  moduleName: _moduleName,
                  onLogout: _handleLogout,
                ),
                Expanded(child: _screen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
