enum PaymentMethod { cash, card, mixed }

class ClosedAccount {
  final int id;
  final String tableName;
  final double total;
  final double cashAmount;
  final double cardAmount;
  final DateTime closedAt;

  const ClosedAccount({
    required this.id,
    required this.tableName,
    required this.total,
    required this.cashAmount,
    required this.cardAmount,
    required this.closedAt,
  });
}

// Mock data with dates relative to today so "Hoy" always shows results
final _now = DateTime.now();
DateTime _d(int daysAgo, int hour, int minute) => DateTime(
      _now.year, _now.month, _now.day - daysAgo, hour, minute);

List<ClosedAccount> initialMockAccounts = [
  // Hoy — Mesa 4 usada dos veces (mediodía y noche)
  ClosedAccount(id: 1,  tableName: 'Mesa 4', total: 990.00,  cashAmount: 990.00,  cardAmount: 0,       closedAt: _d(0, 21, 45)),
  ClosedAccount(id: 2,  tableName: 'Mesa 1', total: 375.00,  cashAmount: 0,       cardAmount: 375.00,  closedAt: _d(0, 20, 30)),
  ClosedAccount(id: 3,  tableName: 'Mesa 7', total: 1260.00, cashAmount: 889.20,  cardAmount: 370.80,  closedAt: _d(0, 19, 15)),
  ClosedAccount(id: 4,  tableName: 'Mesa 3', total: 615.00,  cashAmount: 0,       cardAmount: 615.00,  closedAt: _d(0, 18, 00)),
  ClosedAccount(id: 10, tableName: 'Mesa 4', total: 420.00,  cashAmount: 420.00,  cardAmount: 0,       closedAt: _d(0, 14, 20)),
  ClosedAccount(id: 11, tableName: 'Mesa 1', total: 180.00,  cashAmount: 0,       cardAmount: 180.00,  closedAt: _d(0, 13, 05)),
  // Ayer
  ClosedAccount(id: 5,  tableName: 'Mesa 2', total: 480.00,  cashAmount: 480.00,  cardAmount: 0,       closedAt: _d(1, 22, 00)),
  ClosedAccount(id: 6,  tableName: 'Mesa 5', total: 720.00,  cashAmount: 0,       cardAmount: 720.00,  closedAt: _d(1, 20, 45)),
  ClosedAccount(id: 7,  tableName: 'Mesa 6', total: 340.00,  cashAmount: 340.00,  cardAmount: 0,       closedAt: _d(1, 19, 30)),
  // Hace 2 días
  ClosedAccount(id: 8,  tableName: 'Mesa 2', total: 560.00,  cashAmount: 200.00,  cardAmount: 360.00,  closedAt: _d(2, 21, 00)),
  ClosedAccount(id: 9,  tableName: 'Mesa 8', total: 890.00,  cashAmount: 890.00,  cardAmount: 0,       closedAt: _d(2, 20, 15)),
];
