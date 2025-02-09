import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/data/repositories/order_repository.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<Either<Failure, Unit>> create(CreateOrderEntity order) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> finish(FinishOrderEntity order) {
    // TODO: implement finish
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> get() {
    // TODO: implement get
    throw UnimplementedError();
  }
}
