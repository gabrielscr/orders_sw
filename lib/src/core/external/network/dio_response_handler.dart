import 'package:dio/dio.dart';
import 'package:orders_sw/src/core/exception/api_exception.dart';
import 'package:orders_sw/src/core/exception/status_code.dart';
import 'package:orders_sw/src/core/injection/log/log.dart';
import 'package:orders_sw/src/core/injection/log/log_scope.dart';

extension DioResponseHandler on Future<Response<Object?>> {
  Future<T> handleResponse<T>() async {
    try {
      final response = await this;
      final responseData = response.data is List ? response.data : response.data as Map<String, dynamic>?;

      if (responseData == null) {
        throw ApiException(
          'No data',
          response.statusCode ?? StatusCode.e500,
        );
      }

      late final Object data;

      data = responseData;

      Log().verbose(
        '$data',
        name: LogScope.api,
      );

      if (data is List && data.isEmpty && response.requestOptions.method != 'GET') {
        return <String, dynamic>{} as T;
      }

      return data as T;
    } on DioException catch (error) {
      final response = error.response?.data;

      late Map<String, dynamic>? responseData;

      if (response is String) {
        responseData = {'data': response};
      } else {
        responseData = response;
      }

      final statusCode = error.response?.statusCode ?? StatusCode.e500;

      final tag = responseData?['code'];

      final message = responseData?['message'] ?? error.message ?? '';

      final errorData = {
        'code': '$statusCode',
        'message': '$tag - $message',
      };
      final method = error.requestOptions.method.toUpperCase();

      final baseUrl = error.requestOptions.baseUrl;
      final path = error.requestOptions.path;

      Log().warning(
        '$method | $baseUrl | $path | ${errorData.values.join(' - ')}',
        name: LogScope.api,
      );

      if (error.message?.contains('Failed host lookup') ?? false) {
        Log().error('No connection', name: LogScope.api);
      }

      throw ApiException(
        tag.toString(),
        statusCode,
      );
    }
  }
}
