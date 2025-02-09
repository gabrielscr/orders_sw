import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';

class CreateOrderModel extends CreateOrderEntity {
  const CreateOrderModel({
    required super.description,
    required super.customerName,
  });

  factory CreateOrderModel.fromMap(Map<String, dynamic> json) {
    return CreateOrderModel(
      description: json['description'],
      customerName: json['customerName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'customerName': customerName,
    };
  }

  CreateOrderModel copyWith({
    String? description,
    String? customerName,
  }) {
    return CreateOrderModel(
      description: description ?? this.description,
      customerName: customerName ?? this.customerName,
    );
  }

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) {
    return CreateOrderModel(
      description: entity.description,
      customerName: entity.customerName,
    );
  }

  CreateOrderEntity toEntity() {
    return CreateOrderEntity(
      description: description,
      customerName: customerName,
    );
  }
}
