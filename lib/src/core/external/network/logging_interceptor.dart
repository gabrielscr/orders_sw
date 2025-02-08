import 'package:dio/dio.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  LoggingInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Log().info(
      '${options.method.toUpperCase()} | ${options.path} | ${options.data ?? ''} | ${options.queryParameters}',
      name: LogScope.api,
    );

    handler.next(options);
  }
}
