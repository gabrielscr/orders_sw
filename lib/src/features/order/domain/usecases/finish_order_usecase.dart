import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/data/repositories/order_repository.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class FinishOrderUsecase {
  final OrderRepository _orderRepository;

  const FinishOrderUsecase({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository;

  Future<Either<Failure, OrderEntity>> call(FinishOrderEntity order) async {
    return await _orderRepository.finish(order);
  }
}
