import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/route/global_keys.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/core/route/router_log_observer.dart';
import 'package:orders_sw/src/core/route/routes.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';
import 'package:orders_sw/src/features/auth/presentation/views/auth_view.dart';
import 'package:orders_sw/src/features/auth/presentation/views/splash_view.dart';
import 'package:orders_sw/src/features/auth/presentation/views/user_view.dart';
import 'package:orders_sw/src/features/order/domain/entities/order_entity.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_create_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_detail_view.dart';
import 'package:orders_sw/src/features/order/presentation/views/order_finish_view.dart';
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
      path: RoutePath.user,
      name: Routes.user,
      builder: (_, __) => const UserView(),
    ),
    GoRoute(
      path: RoutePath.orders,
      name: Routes.orders,
      builder: (_, __) => const OrdersView(),
    ),
    GoRoute(
      path: RoutePath.orderDetail,
      name: Routes.orderDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return _onError(context, state);
        }

        return OrderDetailView(
          order: extra['order'] as OrderEntity,
        );
      },
    ),
    GoRoute(
      path: RoutePath.orderCreate,
      name: Routes.orderCreate,
      builder: (_, __) => const OrderCreateView(),
    ),
    GoRoute(
      path: RoutePath.orderFinish,
      name: Routes.orderFinish,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return _onError(context, state);
        }

        return OrderFinishView(
          order: extra['order'] as OrderEntity,
        );
      },
    ),
  ],
  navigatorKey: GlobalKeys.rootNavigatorKey,
  errorBuilder: (context, state) => _onError(context, state),
  redirect: (context, state) async => await _onRedirect(state),
);

Widget _onError(BuildContext context, GoRouterState state) {
  return Material(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Erro'),
      ),
      body: const Center(
        child: Text('Ops! Rota não encontrada'),
      ),
    ),
  );
}

FutureOr<String?> _onRedirect(GoRouterState state) async {
  await Future.delayed(Duration.zero);

  final route = state.fullPath ?? '';
  Log().debug('🔄 [GoRouter] Redirecionamento em andamento... Rota atual: $route');

  final unauthenticatedRoutes = <String>[
    RoutePath.splash,
    RoutePath.login,
  ];

  if (unauthenticatedRoutes.contains(route)) {
    return null;
  }

  final isAuthenticated = getIt<TokenService>().isAuthenticated;
  Log().debug('🔍 [GoRouter] isAuthenticated atualizado? $isAuthenticated');

  if (!isAuthenticated) {
    Log().debug('🚫 [GoRouter] Redirecionando para login...');
    return RoutePath.login;
  }

  return null;
}
