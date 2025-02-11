import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/route/global_keys.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/route/router_log_observer.dart';
import 'package:orders_sw/src/core/route/routes.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';
import 'package:orders_sw/src/features/auth/presentation/views/auth_view.dart';
import 'package:orders_sw/src/features/auth/presentation/views/splash_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_detail_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/orders_view.dart';

final router = GoRouter(
  initialLocation: RoutePath.splash,
  observers: <NavigatorObserver>[
    RouterLogObserver(),
  ],
  routes: [
    GoRoute(
      path: RoutePath.splash,
      name: Routes.splash,
      builder: (_, __) => const SplashView(),
    ),
    GoRoute(
      path: RoutePath.login,
      name: Routes.login,
      builder: (_, __) => const AuthView(),
    ),
    GoRoute(
      path: RoutePath.orders,
      name: Routes.orders,
      builder: (_, __) => const OrdersView(),
      routes: [
        GoRoute(
          path: RoutePath.orderDetail,
          name: Routes.orderDetail,
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return const OrderDetailView();
          },
        ),
      ],
    ),
  ],
  navigatorKey: GlobalKeys.rootNavigatorKey,
  errorBuilder: (context, state) => const Material(
    child: Center(
      child: Text('Rota não encontrada'),
    ),
  ),
  redirect: (context, state) async => await _onRedirect(state),
);

FutureOr<String?> _onRedirect(GoRouterState state) async {
  final route = state.fullPath ?? '';

  final unauthenticatedRoutes = <String>[
    RoutePath.splash,
    RoutePath.login,
  ];

  if (unauthenticatedRoutes.any((path) => path == route)) {
    return null;
  }

  final isAuthenticated = await getIt<TokenService>().isAuthenticated();

  if (!isAuthenticated) {
    return RoutePath.login;
  }

  return null;
}
