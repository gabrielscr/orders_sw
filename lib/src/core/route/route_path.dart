import 'package:orders_sw/src/core/route/routes.dart';

class RoutePath {
  static final String splash = '/$_splash';
  static final String login = '/$_login';
  static final String orders = '/$_orders';
  static final String orderDetail = '/$_orderDetail/:id';
  static final String orderFinish = '/$_orderFinish/:id';
  static final String notFound = '/$_notFound';

  static String get _splash => Routes.splash;
  static String get _login => Routes.login;
  static String get _orders => Routes.orders;
  static String get _orderDetail => Routes.orderDetail;
  static String get _orderFinish => Routes.orderFinish;
  static String get _notFound => Routes.notFound;
}
