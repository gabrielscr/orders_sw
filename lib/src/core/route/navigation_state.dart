import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/navigation_exception.dart';

import 'base_routes.dart';
import 'navigation_route.dart';

abstract class NavigationState with ChangeNotifier {
  List<NavigationPage> get stack;
  void addRoute(RoutePath route, BuildContext context, {dynamic params, OnPopNavigation? onPopNavigation});
  void setRoute(RoutePath baseRoute, {RoutePath? subRoute, dynamic params});
  bool removeRoute([dynamic params]);
  bool onBackButton();
}

class NavigationStateImpl extends NavigationState {
  late final Map<BaseRoutes, NavigationRoute> _pages;
  late List<NavigationPage> _stack;
  @override
  List<NavigationPage> get stack => _stack;
  late NavigationRoute _selectedPage;

  NavigationStateImpl({Map<BaseRoutes, NavigationRoute> Function() builderPages = defaultBuilderPages, BaseRoutes? initialRoute, RoutePath? subRoute, dynamic params}) {
    final initialPage = initialRoute ?? BaseRoutes.auth;
    _pages = builderPages();
    _selectedPage = _pages[initialPage]!;

    _stack = [NavigationPage(navigationMaterialPage: _findRoutes(subRoute ?? initialPage, params: params), baseRoute: initialPage)];
  }

  void _selectPage(RoutePath route) {
    final isChangingPage = route is BaseRoutes;
    if (!isChangingPage) {
      return;
    }

    if (!_pages.containsKey(route)) {
      throw const NavigationException('Route not found');
    }

    _selectedPage = _pages[route]!;
  }

  NavigationMaterialPage _findRoutes(RoutePath route, {dynamic params = const {}}) {
    final NavigationMaterialPage result = _selectedPage.routes(route: route, params: params);

    return result;
  }

  @override
  void addRoute(RoutePath route, BuildContext context, {dynamic params, OnPopNavigation? onPopNavigation}) {
    _selectPage(route);
    _stack.last.context = context;
    _stack.add(
      NavigationPage(navigationMaterialPage: _findRoutes(route, params: params), onPopNavigation: onPopNavigation, baseRoute: route is BaseRoutes ? route : _stack.last.baseRoute),
    );

    notifyListeners();
  }

  @override
  void setRoute(RoutePath baseRoute, {RoutePath? subRoute, dynamic params}) {
    final context = _stack.first.context;
    _stack.clear();
    _selectPage(baseRoute);
    _stack = [NavigationPage(navigationMaterialPage: _findRoutes(subRoute ?? baseRoute, params: params))];
    _onPopNavigationLastPage(params, context);
    notifyListeners();
  }

  @override
  bool removeRoute([dynamic params]) {
    if (_stack.length > 1) {
      final poppedPage = _stack.removeLast();

      if (stack.last.baseRoute != null) {
        _selectedPage = _pages[stack.last.baseRoute]!;
      }

      if (_stack.length == 1) {
        _onPopNavigationLastPage(params);

        notifyListeners();
        return true;
      }

      poppedPage.onPopNavigation?.onPop(params, _stack.last.context);

      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  bool onBackButton() {
    if (_stack.length > 1) {
      final injection = stack.last.navigationMaterialPage.child;
      final isNavigationInjection = injection is NavigationInjection;
      final childContainsGlobalKey = isNavigationInjection && injection.child.key is GlobalKey;
      if (isNavigationInjection) {
        if ((childContainsGlobalKey && (injection.child.key as GlobalKey).currentState is OnPopOSBackButtonNavigation)) {
          return ((injection.child.key as GlobalKey).currentState as OnPopOSBackButtonNavigation).onBackButton();
        }
        if (injection.child is OnPopOSBackButtonNavigation) {
          return (injection.child as OnPopOSBackButtonNavigation).onBackButton();
        }
      }
    }
    return true;
  }

  void _onPopNavigationLastPage(params, [BuildContext? context]) {
    if (_stack.last.navigationMaterialPage.child is NavigationInjection) {
      final NavigationInjection injection = _stack.last.navigationMaterialPage.child as NavigationInjection;
      if (injection.child is OnPopNavigation) {
        final OnPopNavigation onPopNavigation = injection.child as OnPopNavigation;
        onPopNavigation.onPop(params, context ?? _stack.last.context);
      }
    }
  }
}
