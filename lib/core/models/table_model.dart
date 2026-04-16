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

class TableModel {
  final int id;
  final String name;
  final int capacity;
  final TableStatus status;

  const TableModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.status,
  });
}

const mockTables = [
  TableModel(id: 1, name: 'Mesa 1', capacity: 4, status: TableStatus.occupied),
  TableModel(id: 2, name: 'Mesa 2', capacity: 2, status: TableStatus.available),
  TableModel(id: 3, name: 'Mesa 3', capacity: 6, status: TableStatus.billRequested),
  TableModel(id: 4, name: 'Mesa 4', capacity: 3, status: TableStatus.occupied),
  TableModel(id: 5, name: 'Mesa 5', capacity: 4, status: TableStatus.available),
  TableModel(id: 6, name: 'Mesa 6', capacity: 5, status: TableStatus.occupied),
];
