import 'dart:io';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:orders_sw/src/core/exception/status_code.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';
import 'package:orders_sw/src/core/route/global_keys.dart';
import 'package:orders_sw/src/core/route/route_path.dart';
import 'package:orders_sw/src/features/auth/domain/entities/user_token.dart';
import 'package:orders_sw/src/features/auth/domain/services/token_service.dart';

class TokenInterceptor extends InterceptorsWrapper {
  TokenInterceptor({required TokenService tokenService}) : _tokenService = tokenService;

  final TokenService _tokenService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final userToken = await _tokenService.getToken();

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
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == StatusCode.e401) {
      final oldToken = await _tokenService.getToken();

      if (oldToken == null) {
        Log().warning('No Access Token found', name: LogScope.api);
        _redirectToLogin();
        return handler.next(err);
      }

      final response = await _tokenService.getRefreshToken(oldToken.accessToken);

      UserTokenEntity? refreshToken;
      bool refreshFailed = false;

      response.fold(
        (failure) {
          Log().error('Token refresh failed', name: LogScope.api);
          refreshFailed = true;
        },
        (token) {
          refreshToken = token;
          Log().info('Token refreshed successfully', name: LogScope.api);
        },
      );

      if (refreshFailed || refreshToken == null) {
        await _tokenService.clearToken();
        _redirectToLogin(); 
        return handler.next(err);
      }

      await _tokenService.saveToken(token: refreshToken!);
      final RequestOptions requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer ${refreshToken!.accessToken}';

      try {
        final response = await Dio().fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  void _redirectToLogin() {
    final context = GlobalKeys.rootNavigatorKey.currentContext;
    if (context != null) {
      Log().info('Redirecting to login...', name: LogScope.auth);
      context.pushReplacement(RoutePath.login);
    }
  }
}
