import 'package:flutter/material.dart';
import 'package:orders_sw/src/core/route/base_routes.dart';

abstract mixin class OnPopNavigation {
  void onPop(dynamic params, BuildContext context);
}

abstract mixin class OnPopOSBackButtonNavigation {
  bool onBackButton();
}

abstract class NavigationRoute<D> {
  NavigationMaterialPage routes({required D route, dynamic params});
}

abstract class NavigationInjection extends StatelessWidget {
  final Widget child;

  const NavigationInjection({super.key, required this.child});
}

class NavigationMaterialPage extends MaterialPage {
  NavigationMaterialPage({
    NavigationInjection Function()? child,
    super.key,
  }) : super(
          child: child!.call(),
        );
}

class NavigationPage {
  final NavigationMaterialPage navigationMaterialPage;
  final OnPopNavigation? onPopNavigation;
  final OnPopOSBackButtonNavigation? onPopOSBackButtonNavigation;
  final BaseRoutes? baseRoute;
  late BuildContext context;

  NavigationPage({
    required this.navigationMaterialPage,
    this.onPopNavigation,
    this.onPopOSBackButtonNavigation,
    this.baseRoute,
  });
}
