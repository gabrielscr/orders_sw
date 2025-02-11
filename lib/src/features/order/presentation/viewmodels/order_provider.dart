import 'package:flutter/material.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';
import 'package:orders_sw/src/features/order/domain/usecases/create_order_usecase.dart';
import 'package:orders_sw/src/features/order/domain/usecases/finish_order_usecase.dart';
import 'package:orders_sw/src/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:orders_sw/src/features/order/presentation/viewmodels/order_state.dart';

class OrderProvider extends ChangeNotifier {
  final GetOrdersUsecase _getOrdersUsecase;
  final FinishOrderUsecase _finishOrderUsecase;
  final CreateOrderUsecase _createOrderUsecase;

  OrderProvider({
    required GetOrdersUsecase getOrdersUsecase,
    required FinishOrderUsecase finishOrderUsecase,
    required CreateOrderUsecase createOrderUsecase,
  })  : _getOrdersUsecase = getOrdersUsecase,
        _finishOrderUsecase = finishOrderUsecase,
        _createOrderUsecase = createOrderUsecase;

  OrderState _state = const OrderState();

  OrderState get state => _state;

  void _updateState(OrderState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> init() async {
    _updateState(
      OrderState.loading(),
    );

    final result = await _getOrdersUsecase();

    result.fold(
      (failure) {
        _updateState(
          OrderState.error(failure: failure),
        );
      },
      (orders) => _updateState(
        OrderState.success(orders),
      ),
    );
  }

  Future<void> finishOrder({required OrderEntity order}) async {
    _updateState(
      OrderState.loading(),
    );

    final result = await _finishOrderUsecase(FinishOrderEntity(id: order.id, description: order.description, customerName: order.customerName));

    result.fold(
      (failure) {
        _updateState(
          OrderState.finishError(),
        );
      },
      (order) => _updateState(
        OrderState.finish(order),
      ),
    );
  }

  Future<void> createOrder({required String description, required String customerName}) async {
    _updateState(
      OrderState.loading(),
    );

    final result = await _createOrderUsecase(CreateOrderEntity(description: description, customerName: customerName));

    result.fold(
      (failure) {
        _updateState(
          OrderState.createError(),
        );
      },
      (order) => _updateState(
        OrderState.created(order),
      ),
    );
  }

  void resetState() {
    _updateState(
      OrderState.initial(),
    );
  }
}
