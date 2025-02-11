import 'package:equatable/equatable.dart';
import 'package:orders_sw/src/core/exception/failure.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  empty,
  error,
  created,
  createError,
  finish,
  finishError,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderEntity> orders;
  final OrderEntity? order;
  final Failure? failure;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.order,
    this.failure,
  });

  factory OrderState.initial() => const OrderState(
        status: OrderStatus.initial,
      );

  factory OrderState.loading() {
    return const OrderState(
      status: OrderStatus.loading,
    );
  }

  factory OrderState.success(List<OrderEntity> orders) {
    return OrderState(
      status: OrderStatus.success,
      orders: orders,
    );
  }

  factory OrderState.empty() {
    return const OrderState(
      status: OrderStatus.empty,
    );
  }

  factory OrderState.error({required Failure failure}) {
    return  OrderState(
      status: OrderStatus.error,
      failure: failure,
    );
  }

  factory OrderState.finish(OrderEntity order) {
    return OrderState(
      status: OrderStatus.finish,
      order: order,
    );
  }

  factory OrderState.finishError() {
    return const OrderState(
      status: OrderStatus.finishError,
    );
  }

  factory OrderState.created(OrderEntity order) {
    return OrderState(
      status: OrderStatus.created,
      order: order,
    );
  }

  factory OrderState.createError() {
    return const OrderState(
      status: OrderStatus.createError,
    );
  }

  OrderState copyWith({
    OrderStatus? status,
    List<OrderEntity>? orders,
    OrderEntity? order,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [status, orders, order];
}
