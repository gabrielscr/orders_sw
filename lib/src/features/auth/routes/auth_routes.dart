import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';
import 'package:orders_sw/src/core/route/navigation_route.dart';
import 'package:orders_sw/src/features/auth/presentation/views/auth_view.dart';
import 'package:provider/provider.dart';

class AuthInjection extends NavigationInjection {
  const AuthInjection({super.key, required super.child});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => const AuthView(),
      child: child,
    );
  }
}

class AuthRoutes implements NavigationRoute<RoutePath> {
  @override
  NavigationMaterialPage routes({required RoutePath route, params}) {
    return switch (route) {
      _ => NavigationMaterialPage(
          child: () => const AuthInjection(
            child: AuthView(),
          ),
        ),
    };
  }

  const AuthRoutes();
}
