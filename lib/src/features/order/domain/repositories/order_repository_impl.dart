import 'package:dartz/dartz.dart';
import 'package:orders_sw/src/core/constants/endpoints.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/core/external/network/exception_handler.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';
import 'package:orders_sw/src/features/order/data/models/create_order_model.dart';
import 'package:orders_sw/src/features/order/data/models/finish_order_model.dart';
import 'package:orders_sw/src/features/order/data/models/order_model.dart';
import 'package:orders_sw/src/features/order/data/repositories/order_repository.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

class OrderRepositoryImpl implements OrderRepository {
  final HttpService _httpService;

  const OrderRepositoryImpl({required HttpService httpService}) : _httpService = httpService;

  @override
  Future<Either<Failure, OrderEntity>> create(CreateOrderEntity order) async {
    try {
      final response = await _httpService.post(
        Endpoints.createOrder,
        body: CreateOrderModel.fromEntity(order).toMap(),
      );

      return Right(OrderModel.fromMap(response).toEntity());
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> finish(FinishOrderEntity order) async {
    try {
      final response = await _httpService.post(
        Endpoints.finishOrder(order.id),
        body: FinishOrderModel.fromEntity(order).toMap(),
      );

      return Right(OrderModel.fromMap(response).toEntity());
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> get() async {
    try {
      final response = await _httpService.get(Endpoints.orders);

      if (!response is List) {
        return Left(Failure.general());
      } else if (response.isEmpty) {
        return const Right([]);
      }

      final orders = (response as List).map((e) => OrderModel.fromEntity(e).toEntity()).toList();

      return Right(orders);
    } on Exception catch (e) {
      return e.handleFailure();
    }
  }
}
