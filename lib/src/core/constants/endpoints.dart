class Endpoints {
  static const String emitToken = '/connect/token';
  static const String refreshToken = '/connect/token';
  static const String revokeToken = '/connect/revocation';

  static const String user = '/users/me';

  static const String orders = '/orders';
  static const String createOrder = '/orders';
  static String finishOrder(String orderId) => '/orders/$orderId/finish';
}
