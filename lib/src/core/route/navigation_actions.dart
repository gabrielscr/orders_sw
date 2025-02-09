import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';
import 'package:orders_sw/src/core/route/navigation_route.dart';

abstract interface class NavigationAction<T> {
  void Function(T route, {dynamic params, OnPopNavigation? onPopNavigation}) get navigate;

  void Function([dynamic params]) pop();

  static NavigationAction<T> of<T extends RoutePath>(BuildContext context) => context.dependOnInheritedWidgetOfExactType<NavigationActionImpl<T>>()!
    .._currentContext.clear()
    .._currentContext.add(context);
}

class NavigationActionImpl<T> extends InheritedWidget implements NavigationAction<T> {
  final void Function(T route, BuildContext context, {dynamic params, OnPopNavigation? onPopNavigation}) _navigate;
  @override
  void Function(T route, {dynamic params, OnPopNavigation? onPopNavigation}) get navigate => (T route, {dynamic params, OnPopNavigation? onPopNavigation}) {
        Log().verbose('NAVIGATE: $route', name: LogScope.route);
        return _navigate(route, _currentContext.first, params: params, onPopNavigation: onPopNavigation);
      };

  final void Function([dynamic params]) _pop;
  @override
  void Function([dynamic params]) pop([dynamic params]) {
    Log().verbose('POP: ${params ?? ''}', name: LogScope.route);
    return _pop;
  }

  final List<BuildContext> _currentContext = [];

  NavigationActionImpl({
    super.key,
    required void Function(T route, BuildContext context, {dynamic params, OnPopNavigation? onPopNavigation}) navigate,
    required void Function([dynamic params]) pop,
    required super.child,
  })  : _navigate = navigate,
        _pop = pop;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
