import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final DateTime createdAt;
  final String description;
  final String customerName;
  final bool finished;

  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.description,
    required this.customerName,
    required this.finished,
  });

  @override
  List<Object?> get props => [id, createdAt, description, customerName, finished];
}
