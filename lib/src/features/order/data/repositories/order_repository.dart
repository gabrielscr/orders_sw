import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> get();
  Future<Either<Failure, OrderEntity>> create(CreateOrderEntity order);
  Future<Either<Failure, OrderEntity>> finish(FinishOrderEntity order);
}
