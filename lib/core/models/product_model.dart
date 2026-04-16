class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isActive;

  const ProductModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    required this.category,
    this.isActive = true,
  });

  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    String? category,
    bool? isActive,
  }) =>
      ProductModel(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        category: category ?? this.category,
        isActive: isActive ?? this.isActive,
      );
}

// Categorías sin "Todas" — "Todas" solo aplica al selector del panel
const productSections = ['Bebidas', 'Botellas', 'Alimentos', 'Mixología'];

// Para el panel selector de la orden
const productCategories = ['Todas', ...productSections];

List<ProductModel> initialMockProducts = [
  ProductModel(id: 1,  name: 'Cerveza',             description: 'Cerveza clara 355ml',       price: 60,  category: 'Bebidas'),
  ProductModel(id: 2,  name: 'Michelada',            description: 'Con clamato y limón',       price: 90,  category: 'Bebidas'),
  ProductModel(id: 3,  name: 'Tequila Shot',         description: 'Shot 60ml',                 price: 45,  category: 'Bebidas'),
  ProductModel(id: 4,  name: 'Mojito',               description: 'Con menta y limón',         price: 85,  category: 'Mixología'),
  ProductModel(id: 5,  name: 'Margarita',            description: 'Clásica con sal',           price: 90,  category: 'Mixología'),
  ProductModel(id: 6,  name: 'Whisky',               description: 'En las rocas 60ml',         price: 120, category: 'Bebidas'),
  ProductModel(id: 7,  name: 'Vodka',                description: 'Shot 60ml',                 price: 100, category: 'Bebidas'),
  ProductModel(id: 8,  name: 'Ron',                  description: 'Shot 60ml',                 price: 95,  category: 'Bebidas'),
  ProductModel(id: 9,  name: 'Botella Vodka Premium',description: 'Vodka importado 750ml',     price: 850, category: 'Botellas'),
  ProductModel(id: 10, name: 'Botella Ron Añejo',    description: 'Ron añejo 7 años 750ml',    price: 780, category: 'Botellas'),
  ProductModel(id: 11, name: 'Botella Whisky',       description: 'Whisky escocés 750ml',      price: 950, category: 'Botellas'),
  ProductModel(id: 12, name: 'Refresco',             description: 'Lata 355ml',                price: 30,  category: 'Bebidas'),
  ProductModel(id: 13, name: 'Agua',                 description: 'Botella 600ml',             price: 25,  category: 'Bebidas'),
  ProductModel(id: 14, name: 'Nachos',               description: 'Con queso y jalapeños',     price: 120, category: 'Alimentos'),
  ProductModel(id: 15, name: 'Alitas',               description: '10 piezas BBQ o búfalo',    price: 150, category: 'Alimentos'),
  ProductModel(id: 16, name: 'Papas',                description: 'Fritas con aderezo',        price: 80,  category: 'Alimentos'),
];
