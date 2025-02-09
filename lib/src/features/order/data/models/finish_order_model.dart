import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';

class FinishOrderModel extends FinishOrderEntity {
  const FinishOrderModel({
    required super.id,
    required super.description,
    required super.customerName,
  });

  factory FinishOrderModel.fromMap(Map<String, dynamic> json) {
    return FinishOrderModel(
      id: json['id'],
      description: json['description'],
      customerName: json['customerName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'customerName': customerName,
    };
  }


  factory FinishOrderModel.fromEntity(FinishOrderEntity entity) {
    return FinishOrderModel(
      id: entity.id,
      description: entity.description,
      customerName: entity.customerName,
    );
  }

  FinishOrderEntity toEntity() {
    return FinishOrderEntity(
      id: id,
      description: description,
      customerName: customerName,
    );
  }
}