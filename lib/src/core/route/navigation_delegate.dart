import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';
import 'package:orders_sw/src/core/route/navigation_route.dart';
import 'package:orders_sw/src/core/route/navigation_state.dart';

import 'navigation_actions.dart';

class NavigationDelegate extends RouterDelegate<Object> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  final NavigationState _state;

  late RouteObserver<ModalRoute> routeObserver;

  late final Widget Function(BuildContext, Navigator) preBuilder;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey _navigatorActionKey = GlobalKey();

  @override
  Object? get currentConfiguration => null;

  NavigationDelegate({
    required NavigationState state,
    RouteObserver<ModalRoute>? observer,
    Widget Function(BuildContext, Navigator)? preBuilder,
  })  : _state = state,
        super() {
    this.preBuilder = preBuilder ?? (_, navigator) => navigator;
    routeObserver = observer ?? RouteObserver<ModalRoute>();
    _state.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _state.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationActionImpl<RoutePath>(
      key: _navigatorActionKey,
      navigate: navigate,
      pop: popPage,
      child: preBuilder(
        context,
        Navigator(
          key: navigatorKey,
          pages: List.of(_state.stack.map((e) => e.navigationMaterialPage)),
          // ignore: deprecated_member_use
          onPopPage: (route, result) => !route.didPop(result) ? false : popPage(result),
          observers: [routeObserver],
        ),
      ),
    );
  }

  void navigate(RoutePath path, BuildContext context, {dynamic params, OnPopNavigation? onPopNavigation}) => _state.addRoute(path, context, params: params, onPopNavigation: onPopNavigation);
  bool popPage([dynamic params]) => _state.removeRoute(params);

  @override
  Future<bool> popRoute() async {
    final shouldPop = _state.onBackButton();
    if (!shouldPop) {
      return false;
    }
    return popPage();
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}
