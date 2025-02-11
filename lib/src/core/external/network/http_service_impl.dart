import 'package:dio/dio.dart';
import 'package:orders_sw/src/core/external/network/dio_response_handler.dart';
import 'package:orders_sw/src/core/external/network/http_service.dart';

class HttpServiceImpl implements HttpService {
  HttpServiceImpl(this._dio);

  final Dio _dio;

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio
        .get(
          path,
          queryParameters: queryParameters,
        )
        .handleResponse<T>();
  }

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return _dio
        .post(
          path,
          queryParameters: queryParameters,
          data: body,
        )
        .handleResponse<T>();
  }

  @override
  Future<T> postForTokenOnly<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    return _dio
        .post(
          path,
          queryParameters: queryParameters,
          data: body,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        )
        .handleResponse<T>();
  }

  @override
  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return _dio
        .put(
          path,
          data: body,
        )
        .handleResponse<T>();
  }

  @override
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    return _dio
        .delete(
          path,
          data: body,
        )
        .handleResponse<T>();
  }
}
