import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/data/repositories/order_repository.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class GetOrdersUsecase {
  final OrderRepository _orderRepository;

  const GetOrdersUsecase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await _orderRepository.get();
  }
}
