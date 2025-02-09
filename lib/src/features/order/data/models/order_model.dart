import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.createdAt,
    required super.description,
    required super.customerName,
    required super.finished,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      customerName: json['customerName'],
      finished: json['finished'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'customerName': customerName,
      'finished': finished,
    };
  }

  OrderModel copyWith({
    String? id,
    DateTime? createdAt,
    String? description,
    String? customerName,
    bool? finished,
  }) {
    return OrderModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      customerName: customerName ?? this.customerName,
      finished: finished ?? this.finished,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      createdAt: entity.createdAt,
      description: entity.description,
      customerName: entity.customerName,
      finished: entity.finished,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      createdAt: createdAt,
      description: description,
      customerName: customerName,
      finished: finished,
    );
  }
}
