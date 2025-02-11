import 'package:equatable/equatable.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';

enum OrderStatus {
  initial,
  loading,
  success,
  empty,
  error,
  created,
  finish,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderEntity> orders;
  final OrderEntity? order;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.order,
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

  factory OrderState.error() {
    return const OrderState(
      status: OrderStatus.error,
    );
  }

  factory OrderState.finish(OrderEntity order) {
    return OrderState(
      status: OrderStatus.finish,
      order: order,
    );
  }

  factory OrderState.created(OrderEntity order) {
    return OrderState(
      status: OrderStatus.created,
      order: order,
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
