import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';
import 'package:orders_sw/src/core/route/navigation_route.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_detail_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_registration_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/orders_view.dart';

class OrderDetailInjection extends NavigationInjection {
  const OrderDetailInjection({super.key, required super.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class OrderRegistrationInjection extends NavigationInjection {
  const OrderRegistrationInjection({super.key, required super.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class OrdersInjection extends NavigationInjection {
  const OrdersInjection({super.key, required super.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class OrderRoutes implements NavigationRoute<RoutePath> {
  @override
  NavigationMaterialPage routes({required RoutePath route, params}) {
    return switch (route) {
      OrdersSubRoutes.orderDetail => NavigationMaterialPage(
          child: () => OrderDetailInjection(
            child: OrderDetailView(order: params),
          ),
        ),
      OrdersSubRoutes.orderRegistration => NavigationMaterialPage(
          child: () => const OrderRegistrationInjection(
            child: OrderRegistrationView(),
          ),
        ),
      _ => NavigationMaterialPage(
          child: () => const OrdersInjection(
            child: OrdersView(),
          ),
        ),
    };
  }

  const OrderRoutes();
}
