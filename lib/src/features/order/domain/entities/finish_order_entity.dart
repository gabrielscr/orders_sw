import 'package:equatable/equatable.dart';

class FinishOrderEntity extends Equatable {
  final String id;

  final String description;
  final String customerName;

  
  const FinishOrderEntity({
    required this.id,
    required this.description,
    required this.customerName,
  });

  @override
  List<Object?> get props => [id, description, customerName];
}
