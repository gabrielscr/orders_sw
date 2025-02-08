import 'package:orders_sw/src/features/auth/routes/auth_routes.dart';
import 'package:orders_sw/src/features/order/routes/order_routes.dart';

import 'navigation_route.dart';

abstract class RoutePath {}

enum BaseRoutes implements RoutePath {
  auth,
  order,
}

enum AuthSubRoutes implements RoutePath {
  login,
}

enum OrdersSubRoutes implements RoutePath {
  orders,
  orderDetail,
  orderRegistration,
}

Map<BaseRoutes, NavigationRoute> defaultBuilderPages() => const {
      BaseRoutes.auth: AuthRoutes(),
      BaseRoutes.order: OrderRoutes(),
    };
