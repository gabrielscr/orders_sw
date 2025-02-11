import 'package:flutter/material.dart';
import 'package:orders_sw/src/features/order/domain/entities/create_order_entity.dart';
import 'package:orders_sw/src/features/order/domain/entities/finish_order_entity.dart';
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
          OrderState.error(),
        );
      },
      (orders) => _updateState(
        OrderState.success(orders),
      ),
    );
  }

  Future<void> finishOrder() async {
    if (state.order == null) {
      _updateState(
        OrderState.error(),
      );

      return;
    }

    final result = await _finishOrderUsecase(FinishOrderEntity(id: state.order!.id, description: state.order!.description, customerName: state.order!.customerName));

    result.fold(
      (failure) {
        _updateState(
          OrderState.error(),
        );
      },
      (order) => _updateState(
        OrderState.finish(order),
      ),
    );
  }

  Future<void> createOrder({required String description, required String customerName}) async {
    final result = await _createOrderUsecase(CreateOrderEntity(description: description, customerName: customerName));

    result.fold(
      (failure) {
        _updateState(
          OrderState.error(),
        );
      },
      (order) => _updateState(
        OrderState.created(order),
      ),
    );
  }
}
