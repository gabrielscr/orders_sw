import 'dart:io';

import 'package:dio/dio.dart';
import 'package:orders_sw/src/core/exception/status_code.dart';
import 'package:orders_sw/src/core/injection/injections.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/features/auth/domain/services/auth_service.dart';

class TokenInterceptor extends InterceptorsWrapper {
  TokenInterceptor({required AuthService authService}) : _authService = authService;

  final AuthService _authService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final userToken = getIt<AuthService>().token;

    if (userToken == null) {
      Log().warning(
        'No Access Token found',
        name: LogScope.api,
      );

      return handler.next(options);
    }

    options.headers[HttpHeaders.authorizationHeader] = 'Bearer ${userToken.accessToken}';

    Log().info(
      'Access Token: ${options.headers[HttpHeaders.authorizationHeader]}',
      name: LogScope.api,
    );

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == StatusCode.e401) {
      Log().warning(
        'Unauthorized',
        name: LogScope.api,
      );
      await _authService.clearUser();
    }
    handler.next(err);
  }
}
