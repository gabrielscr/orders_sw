import 'package:equatable/equatable.dart';

class CreateOrderEntity extends Equatable {
  final String description;
  final String customerName;

  const CreateOrderEntity({
    required this.description,
    required this.customerName,
  });

  @override
  List<Object?> get props => [description, customerName];
}
