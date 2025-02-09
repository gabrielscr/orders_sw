import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/data/repositories/order_repository.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';

class CreateOrderUsecase {
  final OrderRepository _orderRepository;

  const CreateOrderUsecase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  Future<Either<Failure, Unit>> call(CreateOrderEntity order) async {
    return await _orderRepository.create(order);
  }
}
