import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';

class RouterLogObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    Log().info(
      'PUSHED ${_routeLog(route)}',
      name: LogScope.route,
    );
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    Log().info(
      'POPPED ${_routeLog(route)}',
      name: LogScope.route,
    );
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    Log().info(
      '''REPLACED ${_routeLog(oldRoute)} -> ${_routeLog(newRoute)}''',
      name: LogScope.route,
    );
  }

  String _routeLog(Route? route) {
    return '${_labelRouteType(route)}: ${_routeName(route)}';
  }

  String _labelRouteType(Route? route) {
    if (route is DialogRoute) {
      return 'DIALOG';
    }
    if (route is PopupRoute) {
      return 'POPUP';
    }

    return 'SCREEN';
  }

  String _routeName(Route? route) {
    final String? routeName = route?.settings.name;
    if (routeName != null) {
      return routeName;
    }

    if (route is DialogRoute) {
      return 'Unknown Dialog';
    }
    if (route is PopupRoute) {
      return 'Unknown PopUp';
    }

    return 'Unknown Screen';
  }
}
