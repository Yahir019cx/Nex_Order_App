class InventoryItem {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final int lowStockThreshold;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    this.lowStockThreshold = 5,
  });

  bool get isLowStock => quantity <= lowStockThreshold;

  InventoryItem copyWith({
    String? name,
    String? category,
    int? quantity,
    String? unit,
    int? lowStockThreshold,
  }) =>
      InventoryItem(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      );
}

const inventorySections = ['Botellas', 'Refrescos', 'Mixología', 'Cerveza'];

List<InventoryItem> initialMockInventory = [
  InventoryItem(id: 1,  name: 'Maestro Dobel 750ml',    category: 'Botellas',  quantity: 12, unit: 'botellas', lowStockThreshold: 5),
  InventoryItem(id: 2,  name: 'Centenario 700ml',        category: 'Botellas',  quantity: 3,  unit: 'botellas', lowStockThreshold: 5),
  InventoryItem(id: 3,  name: 'Vodka Premium 750ml',     category: 'Botellas',  quantity: 8,  unit: 'botellas', lowStockThreshold: 5),
  InventoryItem(id: 4,  name: 'Ron Añejo 750ml',         category: 'Botellas',  quantity: 2,  unit: 'botellas', lowStockThreshold: 5),
  InventoryItem(id: 5,  name: 'Whisky Escocés 750ml',    category: 'Botellas',  quantity: 6,  unit: 'botellas', lowStockThreshold: 5),
  InventoryItem(id: 6,  name: 'Coca-Cola 355ml',         category: 'Refrescos', quantity: 48, unit: 'latas',    lowStockThreshold: 12),
  InventoryItem(id: 7,  name: 'Sprite 355ml',            category: 'Refrescos', quantity: 36, unit: 'latas',    lowStockThreshold: 12),
  InventoryItem(id: 8,  name: 'Agua Mineral 600ml',      category: 'Refrescos', quantity: 24, unit: 'botellas', lowStockThreshold: 10),
  InventoryItem(id: 9,  name: 'Jugo de Naranja 1L',      category: 'Refrescos', quantity: 8,  unit: 'litros',   lowStockThreshold: 5),
  InventoryItem(id: 10, name: 'Jugo de Limón 1L',        category: 'Mixología', quantity: 6,  unit: 'litros',   lowStockThreshold: 4),
  InventoryItem(id: 11, name: 'Menta Fresca',            category: 'Mixología', quantity: 3,  unit: 'manojos',  lowStockThreshold: 5),
  InventoryItem(id: 12, name: 'Jarabe de Azúcar 1L',     category: 'Mixología', quantity: 7,  unit: 'litros',   lowStockThreshold: 3),
  InventoryItem(id: 13, name: 'Sal de Gusano',           category: 'Mixología', quantity: 2,  unit: 'frascos',  lowStockThreshold: 3),
  InventoryItem(id: 14, name: 'Cerveza Corona 355ml',    category: 'Cerveza',   quantity: 60, unit: 'botellas', lowStockThreshold: 24),
  InventoryItem(id: 15, name: 'Cerveza Modelo 355ml',    category: 'Cerveza',   quantity: 48, unit: 'botellas', lowStockThreshold: 24),
  InventoryItem(id: 16, name: 'Cerveza Pacífico 355ml',  category: 'Cerveza',   quantity: 20, unit: 'botellas', lowStockThreshold: 24),
  InventoryItem(id: 17, name: 'Cerveza Heineken 355ml',  category: 'Cerveza',   quantity: 15, unit: 'botellas', lowStockThreshold: 12),
];
