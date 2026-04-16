import 'package:flutter/material.dart';

enum TableStatus { available, occupied, billRequested }

extension TableStatusX on TableStatus {
  String get label => switch (this) {
        TableStatus.available     => 'Disponible',
        TableStatus.occupied      => 'Ocupada',
        TableStatus.billRequested => 'Cuenta pedida',
      };

  Color get color => switch (this) {
        TableStatus.available     => const Color(0xFF22C55E),
        TableStatus.occupied      => const Color(0xFFEF4444),
        TableStatus.billRequested => const Color(0xFFF59E0B),
      };
}

class OrderItem {
  final String name;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class TableModel {
  final int id;
  final String name;
  final int capacity;
  final TableStatus status;
  final List<OrderItem> items;

  const TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
    this.items = const [],
  });
}

const mockTables = [
  TableModel(
    id: 1,
    name: 'Mesa 1',
    capacity: 4,
    status: TableStatus.occupied,
    items: [
      OrderItem(name: 'Cerveza',          quantity: 4, unitPrice: 60),
      OrderItem(name: 'Botella vodka',    quantity: 1, unitPrice: 850),
      OrderItem(name: 'Servicio de hielos', quantity: 1, unitPrice: 50),
    ],
  ),
  TableModel(id: 2, name: 'Mesa 2', capacity: 2, status: TableStatus.available),
  TableModel(
    id: 3,
    name: 'Mesa 3',
    capacity: 6,
    status: TableStatus.billRequested,
    items: [
      OrderItem(name: 'Cerveza',          quantity: 4, unitPrice: 60),
      OrderItem(name: 'Botella vodka',    quantity: 1, unitPrice: 850),
      OrderItem(name: 'Servicio de hielos', quantity: 1, unitPrice: 50),
      OrderItem(name: 'Refresco',         quantity: 6, unitPrice: 30),
    ],
  ),
  TableModel(
    id: 4,
    name: 'Mesa 4',
    capacity: 3,
    status: TableStatus.occupied,
    items: [
      OrderItem(name: 'Agua mineral',     quantity: 2, unitPrice: 40),
      OrderItem(name: 'Orden de tacos',   quantity: 3, unitPrice: 120),
    ],
  ),
  TableModel(id: 5, name: 'Mesa 5', capacity: 4, status: TableStatus.available),
  TableModel(
    id: 6,
    name: 'Mesa 6',
    capacity: 5,
    status: TableStatus.occupied,
    items: [
      OrderItem(name: 'Vino tinto',       quantity: 1, unitPrice: 450),
      OrderItem(name: 'Tabla de quesos',  quantity: 1, unitPrice: 280),
    ],
  ),
];
